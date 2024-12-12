//
//  TrackersCollectionViewHeader.swift
//  Tracker
//
//  Created by Sergey Simashov on 05.12.2024.
//

import UIKit

final class TrackersCollectionViewHeader: UICollectionReusableView {
    static let identifier = "Header"
    
    private var titleLabel = UILabel()
    
    var categoryTitle: String = String() {
        didSet {
            titleLabel.text = categoryTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .trackerBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
