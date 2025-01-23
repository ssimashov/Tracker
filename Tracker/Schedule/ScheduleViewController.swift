//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit


protocol ScheduleViewControllerDelegate: AnyObject {
    func updateScheduleInfo(_ weekdays: [Weekday])
}


final class ScheduleViewController: UIViewController {
    
    
    private let weekdays = Array(Weekday.allCases[1..<Weekday.allCases.count] + Weekday.allCases[0..<1])
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    var schedule: [(weekday: Weekday, isChecked: Bool)] = []
    
    
    private lazy var scheduleTableView = UITableView(frame: .zero, style: .plain)
    private lazy var completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        navigationItem.title = NSLocalizedString("schedule", comment: "")
        navigationItem.hidesBackButton = true
        setupCompleteButton()
        setupTableView()
    }
    
    private func setupTableView() {
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        scheduleTableView.allowsSelection = false
        scheduleTableView.rowHeight = 75
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.tableHeaderView = UIView()
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -24),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupCompleteButton() {
        completeButton.setTitleColor(.trackerWhite, for: .normal)
        completeButton.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeButton.backgroundColor = .trackerBlack
        completeButton.layer.cornerRadius = 16.0
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func didTapCompleteButton() {
        let weekdays = Array(schedule.filter({$0.isChecked == true})).map({$0.weekday})
        delegate?.updateScheduleInfo(weekdays)
        navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell
        else {
            return ScheduleTableViewCell()
        }
        
        cell.weekday = weekdays[indexPath.row]
        cell.isSwitchOn = schedule[indexPath.row].isChecked
        cell.delegate = self
        return cell
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func updateSchedule(_ weekday: Weekday) {
        if let index = schedule.firstIndex(where: {$0.weekday == weekday}) {
            schedule[index].isChecked = !schedule[index].isChecked
        }
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == weekdays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.masksToBounds = false
        }
    }
}
