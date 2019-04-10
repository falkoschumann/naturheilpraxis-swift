//
//  main.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 30.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation
import SQLite3

private func openDatabase(_ databasePath: String) -> OpaquePointer {
    var database: OpaquePointer?
    if sqlite3_open(databasePath, &database) == SQLITE_OK {
        return database!
    } else {
        let errmsg = String(cString: sqlite3_errmsg(database)!)
        sqlite3_close(database);
        fatalError("Can not open database: \(errmsg)")
    }
}

private func closeDatabase(_ database: OpaquePointer) {
    sqlite3_close(database);
}

private func openContainer(_ containerPath: String) -> PersistentContainer {
    return PersistentContainer.create(containerPath)
}

do {
    let database = openDatabase("/Users/Shared/Datenbank/Naturheilpraxis/Leipzig.sqlite")
    defer {
        closeDatabase(database)
    }
    let container = openContainer("/Users/Shared/Datenbank/Naturheilpraxis-neu/Naturheilpraxis.sqlite")
    let converter = Converter(database: database,
                              container: container)
    try converter.convert()
} catch {
    print("Can not convert: \(error)")
}
