//
//  TrackersCollectionViewHeader.swift
//  Tracker
//
//  Created by Sergey Simashov on 05.12.2024.
//

import UIKit

final class TrackersCollectionSupplementaryView: UICollectionReusableView {
    var categoryTitle: String = String() {
        didSet {
            titleLabel.text = categoryTitle
        }
    }
    
    static let identifier = "TrackersCollectionHeader"
    
    private lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textAlignment = .left

        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
