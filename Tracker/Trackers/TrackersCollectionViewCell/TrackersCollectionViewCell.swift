//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Sergey Simashov on 11.12.2024.
//

import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func createTrackerRecord(_ id: UUID, _ date: Date)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackersCollectionViewCellDelegate?
    static let identifier = "TrackersCollectionCell"
    
    var tracker: Tracker? {
        didSet {
            trakerTitleLabel.text = tracker?.title
            emojiLabel.text = tracker?.emoji
            cardView.backgroundColor = tracker?.color
            completeButton.backgroundColor = tracker?.color
        }
    }
    
    var date: Date = Date() {
        didSet {
            let isDateHasCome = Calendar.current.startOfDay(for: Date()) < Calendar.current.startOfDay(for: date)
            setCompleteButtonAvailabilyty(to: isDateHasCome)
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            setupCompleteButton(isChecked: isChecked)
        }
    }
    
    var checkCounter: Int = 0 {
        didSet {
            var suffix = String()
            if checkCounter >= 11 && checkCounter < 14 {
                suffix = "дней"
            }
            else if checkCounter % 10 == 1 {
                suffix = "день"
            }
            else if checkCounter % 10 == 2 || checkCounter % 10 == 3 || checkCounter % 10 == 4 {
                suffix = "дня"
            }
            else {
                suffix = "дней"
            }
            completeCounterLabel.text = "\(checkCounter) \(suffix)"
        }
    }

    private lazy var cardView = UIView()
    private lazy var trakerTitleLabel =  UILabel()
    private lazy var emojiLabel = UILabel()
    private lazy var completeCounterLabel = UILabel()
    private lazy var completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    private func setCompleteButtonAvailabilyty(to state: Bool) {
        if state == true {
            completeButton.isEnabled = false
            completeButton.alpha = 0.3
        } else {
            completeButton.isEnabled = true
            completeButton.alpha = 1
        
//        completeButton.isEnabled = !state
//        completeButton.alpha = state ? 0.3 : 1
        }
    }
    
    private func setupCell() {
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        
        emojiLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        emojiLabel.backgroundColor = .trackerWhite.withAlphaComponent(0.3)
        emojiLabel.textAlignment = .center
        
        trakerTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trakerTitleLabel.textColor = .trackerWhite
        trakerTitleLabel.numberOfLines = 4
        
        completeCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        completeCounterLabel.text = "0 день"
        completeCounterLabel.textColor = .trackerBlack
        
        completeButton.setImage(UIImage(systemName: "roundPlus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)), for: .normal)
        completeButton.tintColor = .trackerWhite
        completeButton.imageView?.contentMode = .scaleAspectFit
        
        completeButton.layer.cornerRadius = 17
        completeButton.clipsToBounds = true
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        trakerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        completeCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(trakerTitleLabel)
        cardView.addSubview(emojiLabel)
        contentView.addSubview(cardView)
        contentView.addSubview(completeCounterLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trakerTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trakerTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            trakerTitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
        ])
        
        NSLayoutConstraint.activate([
            completeCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            completeCounterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            completeCounterLabel.heightAnchor.constraint(equalToConstant: 18),
            completeCounterLabel.widthAnchor.constraint(equalToConstant: 101),
        ])
        
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCompleteButton(isChecked: Bool) {
        if isChecked == true {
            completeButton.setImage(UIImage(resource: .done).withTintColor(.trackerWhite), for: .normal)
            completeButton.backgroundColor = completeButton.backgroundColor?.withAlphaComponent(0.3)
        } else {
            completeButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)), for: .normal)
            completeButton.backgroundColor = completeButton.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    @objc
    private func didTapCompleteButton() {
        guard let trackerId = tracker?.id else { return }
        delegate?.createTrackerRecord(trackerId, date)
    }
}
