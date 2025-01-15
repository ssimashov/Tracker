//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Sergey Simashov on 05.01.2025.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private let context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let categories = try? objects.map({ try self.fetchTrackerCategory(from: $0) })
        else { return [] }
        return categories
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch let error {
            print("Can't fetch objects from db: \(error)")
        }
        
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        let mappedTrackers: [TrackerCoreData] = trackerCategory.trackers.map({ tracker in
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = DaysValueTransformer().transformedValue(tracker.schedule) as? NSObject
            return trackerCoreData
        })
        trackerCategoryCoreData.trackers = NSSet(array: mappedTrackers)
        try context.save()
    }
    
    func updateExistCategory(trackerCategoryTitle: String, tracker: Tracker) throws {
        let objects = self.fetchedResultsController?.fetchedObjects
        guard let categorytoUpdate = objects?.first(where: {$0.title == trackerCategoryTitle}) else { return }
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = DaysValueTransformer().transformedValue(tracker.schedule) as? NSObject
        if let categoryTrackers = categorytoUpdate.trackers?.adding(trackerCoreData) {
            categorytoUpdate.trackers = categoryTrackers as NSSet
        }
        try context.save()
    }
    
    private func fetchTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        guard let trackers = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        let trackersArray: [TrackerCoreData] = trackers.allObjects as? [TrackerCoreData] ?? []
        let trackersResult = trackersArray.map { trackerCoreData in
            Tracker(id: trackerCoreData.id ?? UUID(),
                    title: trackerCoreData.title ?? String(),
                    color: trackerCoreData.color as? UIColor ?? UIColor(resource: .trackerRed),
                    emoji: trackerCoreData.emoji ?? String(),
                    schedule: DaysValueTransformer().reverseTransformedValue(trackerCoreData.schedule) as? [Weekday] ?? []
            )
        }
        return TrackerCategory(title: title, trackers: trackersResult)
    }
    
}


extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
}
