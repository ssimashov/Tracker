//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit

protocol ScheduleTableViewCellDelegate: AnyObject {
    func updateSchedule(_ weekday: Weekday)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    static let identifier = "ScheduleCell"
    
    weak var delegate: ScheduleTableViewCellDelegate?
    
    var weekday: Weekday = .sunday {
        didSet {
            titleLabel.text = weekday.fullname
        }
    }
    
    var isSwitchOn: Bool = false {
        didSet {
            switcher.isOn = isSwitchOn
        }
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var switcher = UISwitch()
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .trackerBackground
        setupTitleLabel()
        setupSwitch()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupSwitch() {
        switcher.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switcher.onTintColor = .trackerBlue
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.widthAnchor.constraint(equalToConstant: 31),
            switcher.heightAnchor.constraint(equalToConstant: 51),
            switcher.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            switcher.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            switcher.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -67)
        ])
    }
    
    @objc
    private func switchChanged(_ switcher: UISwitch) {
        delegate?.updateSchedule(weekday)
    }
    
}
