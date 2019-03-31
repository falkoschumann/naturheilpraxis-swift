//
//  Converter.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 31.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation
import SQLite3

class Converter {
    
    let database: OpaquePointer
    let container: PersistentContainer
    
    init() {
        database = Converter.openDatabase()
        container = Converter.openContainer()
    }
    
    private static func openDatabase() -> OpaquePointer {
        var database: OpaquePointer?
        var rc: Int32
    
        rc = sqlite3_open("/Users/Shared/Datenbank/Naturheilpraxis/Leipzig.sqlite", &database)
        if rc != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("Can not open database: \(errmsg)")
            sqlite3_close(database);
            exit(1)
        } else {
            return database!
        }
    }
    
    private static func openContainer() -> PersistentContainer {
        return PersistentContainer.create()
    }
    
    func convertPraxen() {
        var statement: OpaquePointer?
        var rc: Int32
        
        rc = sqlite3_prepare(database, "SELECT id, agency, ordernumber FROM agencylist ORDER BY ordernumber;", -1, &statement, nil)
        if rc != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("SQL error: \(errmsg)");
            return
        }

        let context = container.viewContext
        var first = true
        while sqlite3_step(statement) == SQLITE_ROW {
            // TODO: Wird ID der Praxis gebraucht?
            // let id = sqlite3_column_int64(statement, 0)
            let cString = sqlite3_column_text(statement, 1)
            let agency = String(cString: cString!)
            let ordernumber = sqlite3_column_int64(statement, 2)
            
            let praxis = Praxis(context: context)
            praxis.name = agency
            praxis.reihenfolge = ordernumber
            if first {
                praxis.istStandard = true
                first = false
            }
            print("Insert Praxis: name=\(praxis.name!); ist standard=\(praxis.istStandard); reihenfolge=\(praxis.reihenfolge)")
            context.insert(praxis)
        }

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        do {
            try context.save()
        } catch let error {
            print("Can not save: \(error)")
        }
    }
    
    func close() {
        sqlite3_close(database)
    }

}
