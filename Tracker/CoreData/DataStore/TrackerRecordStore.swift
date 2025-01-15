//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Sergey Simashov on 05.01.2025.
//

import UIKit
import CoreData


enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
}


final class TrackerRecordStore: NSObject {

    private let context: NSManagedObjectContext
    
    var completedTrackers: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let completedTrackers = try? objects.map({ try self.fetchTrackerRecord(from: $0) })
        else { return [] }
        return completedTrackers
    }
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
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
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        try context.save()
    }
    
    func removeTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let objects = self.fetchedResultsController?.fetchedObjects
        guard let recordToDelete = objects?.first(where: {$0.id == trackerRecord.id && Calendar.current.isDate($0.date ?? Date(), inSameDayAs: trackerRecord.date)}) else { return }
        context.delete(recordToDelete)
        try context.save()
    }
    
    private func fetchTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        return TrackerRecord(id: id, date: date)
    }
}
