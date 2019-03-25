//
//  SQLiteImporter.swift
//  Naturheilpraxis
//
//  Created by Falko Schumann on 25.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Cocoa
import SQLite3

class SQLiteImporter {
    
    private let container: NSPersistentContainer
    
    init(_ container: NSPersistentContainer) {
        self.container = container
    }
    
    func importFile() -> Bool {
        /*
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.sqlite")
        */

        var db: OpaquePointer?
        if sqlite3_open("/Users/Shared/Datenbank/Naturheilpraxis/Leipzig.sqlite", &db) != SQLITE_OK {
            sqlite3_close(db);
            print("error opening database")
            return false
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare(db, "SELECT id, agency, ordernumber FROM agencylist;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQL error: \(errmsg)");
            return false
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            
            var agency = ""
            if let cString = sqlite3_column_text(statement, 1) {
                agency = String(cString: cString)
            } else {
                print("agency not found")
            }
            
            let ordernumber = sqlite3_column_int64(statement, 2)

            print("id = \(id); agency = \(agency); ordernumber = \(ordernumber)")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        sqlite3_close(db);
        return true
    }
    
}
