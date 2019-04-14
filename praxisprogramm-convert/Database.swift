//
//  Database.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 13.04.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

import SQLite3

func getConnection(url: String) throws -> Connection {
    var database: OpaquePointer?
    guard sqlite3_open(url, &database) == SQLITE_OK else {
        throw getSQLError(database)
    }
    
    return Connection(database!)
}

class Connection {

    private let database: OpaquePointer

    internal init(_ database: OpaquePointer) {
        self.database = database
    }
    
    func prepareStatement(sql: String) throws -> PreparedStatement {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw getSQLError(database)
        }

        return PreparedStatement(database, statement!)
    }
    
    func close() throws {
        guard sqlite3_close(database) == SQLITE_OK else {
            throw getSQLError(database)
        }
    }
    
}

class PreparedStatement {

    private var database: OpaquePointer
    private var statement: OpaquePointer

    internal init(_ database: OpaquePointer, _ statement: OpaquePointer) {
        self.database = database
        self.statement = statement
    }
    
    // TODO setFoo(parameterIndex, x)
    
    func executeQuery() throws -> ResultSet {
        return ResultSet(database, statement)
    }
    
    // TODO executeUpdate() throws -> Int {

    func close() throws {
        guard sqlite3_finalize(statement) == SQLITE_OK else {
            throw getSQLError(database)
        }
    }
    
}

class ResultSet {
    
    private var database: OpaquePointer
    private var statement: OpaquePointer
    
    private var lastColumnIndex: Int32 = 0

    internal init(_ database: OpaquePointer, _ statement: OpaquePointer) {
        self.database = database
        self.statement = statement
    }
    
    func next() throws -> Bool {
        switch sqlite3_step(statement) {
        case SQLITE_ROW:
            return true
        case SQLITE_DONE:
            return false
        default:
            throw getSQLError(database)
        }
    }
    
    // TODO Fehlerbehandlung für getXXX(); z.B. fehlerhafter Spaltenindex
    
    func getString(columnIndex: Int) throws -> String {
        lastColumnIndex = Int32(columnIndex)
        let text = sqlite3_column_text(statement, lastColumnIndex)
        return String(cString: text!)
    }
    
    func getInt32(columnIndex: Int) throws -> Int32 {
        lastColumnIndex = Int32(columnIndex)
        return sqlite3_column_int(statement, lastColumnIndex)
    }
    
    func getInt64(columnIndex: Int) throws -> Int64 {
        lastColumnIndex = Int32(columnIndex)
        return sqlite3_column_int64(statement, lastColumnIndex)
    }
    
    func getDouble(columnIndex: Int) throws -> Double {
        lastColumnIndex = Int32(columnIndex)
        return sqlite3_column_double(statement, lastColumnIndex)
    }
    
    func wasNull() -> Bool {
        return sqlite3_column_type(statement, lastColumnIndex) == SQLITE_NULL
    }
    
    func close() throws {
        guard sqlite3_finalize(statement) == SQLITE_OK else {
            throw getSQLError(database)
        }
    }
    
}

struct SQLError : Error {
    let code: Int
    let message: String
}

private func getSQLError(_ database: OpaquePointer?) -> SQLError {
    let errcode = sqlite3_errcode(database)
    let errmsg = String(cString: sqlite3_errmsg(database))
    return SQLError(code: Int(errcode), message: errmsg)
}
