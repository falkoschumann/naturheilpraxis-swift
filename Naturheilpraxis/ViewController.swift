//
//  ViewController.swift
//  Naturheilpraxis
//
//  Created by Falko Schumann on 13.03.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = NSApplication.shared.delegate as! AppDelegate
        container = app.persistentContainer
        let stores = container.persistentStoreCoordinator.persistentStores
        for store in stores {
            print("Store type: ", store.metadata[NSStoreTypeKey])
            print("Store url: ", store.url)
        }
        
        //insertNewPatient()
        //fetchPatienten()
        
        // Do any additional setup after loading the view.
    }

    private func insertNewPatient() {
        do {
            let context = container.viewContext
            
            let patient = Patient(context: context)
            patient.vorname = "Falko"
            patient.nachname = "Schumann"
            patient.geburtstag = ISO8601DateFormatter().date(from: "1979-12-31T00:00")
            context.insert(patient)
            
            try context.save()
        } catch let error {
            print("Insert error: ", error)
        }
    }
    
    private func fetchPatienten() {
        do {
            let context = container.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
            let patienten = try context.fetch(request) as! [Patient]
            for patient in patienten {
                print("Patient: ", patient.nachname, ", ", patient.vorname, ", geboren ", patient.geburtstag)
            }
        } catch let error {
            print("Fetch error", error)
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

