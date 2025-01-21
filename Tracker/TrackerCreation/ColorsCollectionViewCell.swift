//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 13.01.2025.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorsCollectionCell"
    
    var color: Int = Int() {
        didSet {
            outerColorCardView.layer.borderColor = UIColor(rgb: color).withAlphaComponent(0.3).cgColor
            innerColorCardView.backgroundColor = UIColor(rgb: color)
        }
    }
    
    var isPicked: Bool = false {
        didSet {
            outerColorCardView.isHidden = !isPicked
        }
    }
    
    private lazy var outerColorCardView = UIView()
    private lazy var innerColorCardView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell() {
        outerColorCardView.layer.borderWidth = 3
        outerColorCardView.backgroundColor = .trackerWhite.withAlphaComponent(0)
        outerColorCardView.layer.isHidden = false
        
        
        [outerColorCardView,innerColorCardView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        
        NSLayoutConstraint.activate([
            outerColorCardView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            outerColorCardView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            innerColorCardView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -12),
            innerColorCardView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -12),
            innerColorCardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            innerColorCardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
