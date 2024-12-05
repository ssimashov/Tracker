//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 01.12.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        
        setupUI()
    }
    
    @objc private func addTracker() {
        
    }
    
    private func setupUI() {
        // Add tracker button
        let addTrackerButton = UIBarButtonItem(
            image: UIImage(named: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker)
        )
        
        addTrackerButton.tintColor = .trackerBlack
        navigationItem.leftBarButtonItem = addTrackerButton
        
        //Date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
      
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .gregorian)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        
        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .trackerBlack
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        //Search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        
        //PlaceHolder Logo
        let placeholderLogo = UIImageView()
        placeholderLogo.image = UIImage(named: "placeHolderLogo")
        placeholderLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLogo)
        placeholderLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        placeholderLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //PlaceHolder Text
        let placeholderText = UILabel()
        placeholderText.text = "Что будем отслеживать?"
        placeholderText.textColor = .placeholderText
        placeholderText.font = .systemFont(ofSize: 12, weight: .regular)
        placeholderText.textColor = .trackerBlack
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderText)
        placeholderText.topAnchor.constraint(equalTo: placeholderLogo.bottomAnchor, constant: 8).isActive = true
        placeholderText.centerXAnchor.constraint(equalTo: placeholderLogo.centerXAnchor).isActive = true
    }
}
