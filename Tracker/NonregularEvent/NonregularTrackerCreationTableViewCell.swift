//
//  NonregularTrackerCreationTableViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit

final class NonregularTrackerCreationTableViewCell: UITableViewCell {
    var trackerParameterName: String = String() {
        didSet {
            titleLabel.text = trackerParameterName
        }
    }
    
    var trackerParameterDescription: String = String() {
        didSet {
            subtitleLabel.text = trackerParameterDescription
            subtitleLabel.isHidden = subtitleLabel.text?.isEmpty ?? true
        }
    }
    
    static let identifier = "TrackerCreationCell"
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var cellImageView = UIImageView()
    private lazy var cellStackView = UIStackView()
    private lazy var labelsStackView = UIStackView()

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .trackerBackground
        setupCellStackView()
    }
    
    private func setupCellStackView() {
        let cellImage = UIImage(resource: .chevronIcon)
        cellImageView.image = cellImage
        cellImageView.contentMode = .center
        
        titleLabel.textColor = .trackerBlack
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        subtitleLabel.textColor = .trackerGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.isHidden = subtitleLabel.text?.isEmpty ?? true

        cellStackView.axis = .horizontal
        cellStackView.distribution = .equalSpacing
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 2
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        cellStackView.addArrangedSubview(labelsStackView)
        cellStackView.addArrangedSubview(cellImageView)
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.widthAnchor.constraint(equalToConstant: 271),
            cellStackView.heightAnchor.constraint(equalToConstant: 46),
            cellStackView.centerYAnchor.constraint(equalTo: cellStackView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellStackView.heightAnchor.constraint(equalToConstant: 46),
            cellStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
