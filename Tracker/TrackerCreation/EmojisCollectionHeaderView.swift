//
//  EmojisCollectionHeaderView.swift
//  Tracker
//
//  Created by Sergey Simashov on 13.01.2025.
//

import UIKit

final class EmojisCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "EmojisCollectionHeader"
    
    var categoryTitle: String = "" {
        didSet {
            titleLabel.text = categoryTitle
        }
    }   
    
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
