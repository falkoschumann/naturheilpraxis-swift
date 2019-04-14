//
//  Converter.swift
//  praxisprogramm-convert
//
//  Created by Falko Schumann on 31.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation
import CoreData

class Converter {
    
    let connection: Connection
    let container: PersistentContainer
    
    init(connection: Connection, container: PersistentContainer) {
        self.connection = connection
        self.container = container
    }

    func convert() throws {
        try convertPraxen()
        try convertPatienten()
    }
    
    private func convertPraxen() throws {
        let stmt = try connection.prepareStatement(sql: """
            SELECT
                agency
            FROM
                agencylist
            ORDER BY
                ordernumber
            ;
            """)
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
            praxis.name = try rs.getString(columnIndex: 0)
            if first {
                praxis.istStandard = true
                first = false
            }
            context.insert(praxis)
        }
        try context.save()
    }
    
    private func convertPatienten() throws {
        let stmt = try connection.prepareStatement(sql: """
            SELECT
                customerlist.id,
                customerlist.acceptance,
                customerlist.title,
                customerlist.academictitle,
                customerlist.forename,
                customerlist.surname,
                customerlist.street,
                customerlist.streetnumber,
                customerlist.city,
                customerlist.postalcode,
                customerlist.country,
                customerlist.dayofbirth,
                customerlist.callNumber,
                customerlist.mobilephone,
                customerlist.email,
                customerlist.citizenship,
                customerlist.familystatus,
                customerlist.occupation,
                customerlist.childfrom,
                customerlist.partnerfrom,
                customerlist.memorandum,
                agencylist.agency
            FROM
                customerlist
                INNER JOIN agencylist ON customerlist.agencyid = agencylist.id
            ;
            """)
        defer {
            do {
                try stmt.close()
            } catch {
                print("Can not close Statement: \(error)")
            }
        }
        let rs = try stmt.executeQuery()
        let context = container.viewContext
        while (try rs.next()) {
            let praxisName = try rs.getString(columnIndex: 21)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Praxis")
            request.predicate = NSPredicate(format: "name like %@", argumentArray: [praxisName!])
            request.fetchLimit = 1
            let praxen = try context.fetch(request) as! [Praxis]
            let praxis = praxen[0]
            
            // TODO validate email with "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let patient = Patient(context: context)
            patient.praxis = praxis
            patient.patientennummer = try rs.getInt64(columnIndex: 0)
            patient.annahmejahr = try rs.getInt32(columnIndex: 1)
            patient.anrede = try rs.getString(columnIndex: 2)
            patient.titel = try rs.getString(columnIndex: 3)
            patient.vorname = try rs.getString(columnIndex: 4)
            patient.nachname = try rs.getString(columnIndex: 5)
            patient.strasse = try rs.getString(columnIndex: 6)
            patient.hausnummer = try rs.getString(columnIndex: 7)
            patient.wohnort = try rs.getString(columnIndex: 8)
            patient.postleitzahl = try rs.getString(columnIndex: 9)
            patient.staat = try rs.getString(columnIndex: 10)
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = ISO8601DateFormatter.Options.withFullDate
            patient.geburtstag = try dateFormatter.date(from: rs.getString(columnIndex: 11)!)
            patient.telefonnummer = try rs.getString(columnIndex: 12)
            patient.mobilnummer = try rs.getString(columnIndex: 13)
            patient.email = try rs.getString(columnIndex: 14)
            patient.staatsangehoerigkeit = try rs.getString(columnIndex: 15)
            patient.familienstand = try rs.getString(columnIndex: 16)
            patient.beruf = try rs.getString(columnIndex: 17)
            patient.kindVon = try rs.getString(columnIndex: 18)
            patient.partnerVon = try rs.getString(columnIndex: 19)
            patient.notizen = try rs.getString(columnIndex: 20)
            context.insert(patient)
        }
        try context.save()
    }

}
