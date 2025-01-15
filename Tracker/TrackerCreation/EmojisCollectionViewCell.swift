//
//  EmojisCollectionViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 13.01.2025.
//

import UIKit

final class EmojisCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmojisCollectionCell"

    var emoji: String  = "" {
        didSet {
            emojiLabel.text = emoji
        }
    }
    
    var isPicked: Bool = false {
        didSet {
            setEmojiLabelBackgroundColorTransparency(to: !isPicked)
        }
    }
        
    private lazy var emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setEmojiLabelBackgroundColorTransparency(to state: Bool) {
        if state == true {
            emojiLabel.backgroundColor = UIColor.clear
        } else {
            emojiLabel.backgroundColor = .trackerLightgray
        }
    }
    
    private func setupCell() {
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.layer.masksToBounds = true
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        emojiLabel.textAlignment = .center
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            emojiLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
}
