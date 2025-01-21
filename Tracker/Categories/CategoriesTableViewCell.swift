//
//  CategoriesTableViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 20.01.2025.
//

import UIKit

final class CategoriesTableViewCell: UITableViewCell {
    static let identifier = "CategoriesCell"
    
    var categoryTitle: String = String() {
        didSet {
            titleLabel.text = categoryTitle
        }
    }
    
    var isPicked: Bool = false {
        didSet {
            stateImageView.isHidden = !isPicked
        }
    }
    
    private let titleLabel = UILabel()
    private let stateImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .trackerBackground
        setupStateImageView()
        setupTitleLabel()
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: stateImageView.leadingAnchor, constant: -1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupStateImageView() {
        let stateImage = UIImage(resource: .check)
        stateImageView.image = stateImage
        
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stateImageView)
        
        NSLayoutConstraint.activate([
            stateImageView.heightAnchor.constraint(equalToConstant: 24),
            stateImageView.widthAnchor.constraint(equalToConstant: 24),
            stateImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stateImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
