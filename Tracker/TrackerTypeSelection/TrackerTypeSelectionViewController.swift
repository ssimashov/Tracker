//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit

protocol TrackerTypeSelectionViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, _ category: String)
}

final class TrackerTypeSelectionViewController: UIViewController {
    weak var delegate: TrackerTypeSelectionViewControllerDelegate?
    
    private lazy var habitButton = UIButton()
    private lazy var nonregularEventButton = UIButton()
    private lazy var buttonsView = UIView()
    private lazy var buttonsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        navigationItem.title = "Создание трекера"
        setupButtonsStackView()
    }
    
    private func setupButtonsStackView() {
        habitButton.setTitleColor(.trackerWhite, for: .normal)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.backgroundColor = .trackerBlack
        habitButton.layer.cornerRadius = 16.0
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        
        nonregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        nonregularEventButton.backgroundColor = .trackerBlack
        nonregularEventButton.layer.cornerRadius = 16.0
        nonregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nonregularEventButton.addTarget(self, action: #selector(didTapNonregularEventButton), for: .touchUpInside)
        
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        nonregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView.addArrangedSubview(habitButton)
        buttonsStackView.addArrangedSubview(nonregularEventButton)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
        
        NSLayoutConstraint.activate([
            nonregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    @objc
    private func didTapHabitButton() {
        let trackerCreationViewController = TrackerCreationViewController()
        trackerCreationViewController.delegate = self
        navigationController?.pushViewController(trackerCreationViewController, animated: true)
    }
    
    @objc
    private func didTapNonregularEventButton() {
        let nonregularTrackerCreationViewController = NonreglarTrackerCreationViewController()
        nonregularTrackerCreationViewController.delegate = self
        navigationController?.pushViewController(nonregularTrackerCreationViewController, animated: true)
    }
}

extension TrackerTypeSelectionViewController: TrackerCreationViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: String) {
        delegate?.createTracker(tracker, category)
    }
}
