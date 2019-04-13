//
//  Converter.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 31.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

class Converter {
    
    let connection: Connection
    let container: PersistentContainer
    
    init(connection: Connection, container: PersistentContainer) {
        self.connection = connection
        self.container = container
    }

    func convert() throws {
        try convertPraxen()
    }
    
    private func convertPraxen() throws {
        let stmt = try connection.prepareStatement(sql: "SELECT id, agency, ordernumber FROM agencylist ORDER BY ordernumber;")
        defer {
            do {
                try stmt.close()
            } catch {
                print("Can not close Statement: \(error)")
            }
        }
        let rs = try stmt.executeQuery()
        var first = true
        let context = container.viewContext
        while (try rs.next()) {
            let praxis = Praxis(context: context)
            praxis.name = try rs.getString(columnIndex: 1)
            praxis.reihenfolge = try rs.getInt64(columnIndex: 2)
            if first {
                praxis.istStandard = true
                first = false
            }
            print("Insert Praxis: name=\(praxis.name!); ist standard=\(praxis.istStandard); reihenfolge=\(praxis.reihenfolge)")
            context.insert(praxis)
        }
        try context.save()
    }

}
