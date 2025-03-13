//
//  DataBaseService.swift
//  Tracker
//
//  Created by Sergey Simashov on 13.03.2025.
//

import CoreData

final class DataBaseService {
    
    static let shared = DataBaseService()
    
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Load Persistent Store failed: \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private init() {}
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
}
