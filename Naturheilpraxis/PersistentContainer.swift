//
//  PersistentContainer.swift
//  Naturheilpraxis
//
//  Created by Falko Schumann on 24.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Cocoa

class PersistentContainer: NSPersistentContainer {
    
    static func create() -> PersistentContainer {
        let container = PersistentContainer(name: "Naturheilpraxis")
        try! FileManager.default.createDirectory(atPath: "/Users/Shared/Datenbank/Naturheilpraxis-neu", withIntermediateDirectories: true, attributes: nil)
        let fileURL = URL(fileURLWithPath: "/Users/Shared/Datenbank/Naturheilpraxis-neu/Naturheilpraxis.sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: fileURL)]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }
    
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
