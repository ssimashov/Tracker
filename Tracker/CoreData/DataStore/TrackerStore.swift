//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sergey Simashov on 05.01.2025.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private let context: NSManagedObjectContext
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch let error {
            print("Can't fetch objects from db: \(error)")
        }
    }
}
