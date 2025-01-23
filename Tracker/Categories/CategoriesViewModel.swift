//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Sergey Simashov on 21.01.2025.
//

import UIKit

typealias Binding<T> = (T) -> Void

final class CategoriesViewModel {
    private var trackerCategoryStore: TrackerCategoryStore?
    private(set) var pickedCategoryIndex = 0
    
    var onSelectCategory: Binding<String>?
    var onAddCategory: Binding<Void>?
    
    private(set) var categories: [String]  = []
    
    var pickedTitle: String = String()
    
    init(pickedTitle: String) {
        self.pickedTitle = pickedTitle
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            trackerCategoryStore = TrackerCategoryStore(context: context)
        }
        categories = trackerCategoryStore?.categories.map({$0.title}) ?? []
        pickedCategoryIndex = categories.firstIndex(of: pickedTitle) ?? -1
        
    }
    
    func selectCategory(at index: Int) {
        pickedCategoryIndex = index
        onSelectCategory?(categories[index])
    }
    
    func addCategory(categoryTitle: String) {
        if !categories.contains(categoryTitle) {
            categories.append(categoryTitle)
            try? trackerCategoryStore?.addNewTrackerCategory(TrackerCategory(title: categoryTitle, trackers: []))
            onAddCategory?(())
        }
    }
}
