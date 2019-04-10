//
//  Converter.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 31.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation
import SQLite3

enum ConvertingError: Error {
    case database(String)
}

class Converter {
    
    let database: OpaquePointer
    let container: PersistentContainer
    
    init(database: OpaquePointer, container: PersistentContainer) {
        self.database = database
        self.container = container
    }

    func convert() throws {
        try convertPraxen()
    }
    
    private func convertPraxen() throws {
        var statement: OpaquePointer?
        guard sqlite3_prepare(database,
                              "SELECT id, agency, ordernumber FROM agencylist ORDER BY ordernumber;",
                              -1,
                              &statement,
                              nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            throw ConvertingError.database("SQL error: \(errmsg)")
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
        
        try context.save()
    }
    
    func close() {
        sqlite3_close(database)
    }

}
