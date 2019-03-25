//
//  PersistentContainer.swift
//  Naturheilpraxis
//
//  Created by Falko Schumann on 24.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Cocoa

class PersistentContainer: NSPersistentContainer {
    
    var patienten: PatientRepository {
        get {
            return PatientRepository(self)
        }
    }
    
    var praxen: PraxisRepository {
        get {
            return PraxisRepository(self)
        }
    }
    
}

class PatientRepository {
    
    private let container: PersistentContainer
    
    init(_ container: PersistentContainer) {
        self.container = container
    }
    
    func findAll() throws -> [Patient] {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
        return try context.fetch(request) as! [Patient]
    }
    
}

class PraxisRepository {
    
    private let container: PersistentContainer

    init(_ container: PersistentContainer) {
        self.container = container
    }

    func findAll() throws -> [Praxis] {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Praxis")
        request.sortDescriptors = [ NSSortDescriptor(key: "reihenfolge", ascending: true) ]
        return try context.fetch(request) as! [Praxis]
    }
    
}
