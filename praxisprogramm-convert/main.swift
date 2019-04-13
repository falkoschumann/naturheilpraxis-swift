//
//  main.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 30.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

do {
    let connection = try getConnection(url: "/Users/Shared/Datenbank/Naturheilpraxis/Leipzig.sqlite")
    defer {
        do {
            try connection.close()
        } catch {
            print("Can not close connection: \(error)")
        }
    }
    let container = PersistentContainer.create("/Users/Shared/Datenbank/Naturheilpraxis-neu/Naturheilpraxis.sqlite")
    let converter = Converter(connection: connection, container: container)
    try converter.convert()
} catch {
    print("Could not convert: \(error)")
}
