//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit

protocol TrackerCreationViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, _ category: String)
}

final class TrackerCreationViewController: UIViewController {
    
    private let weekdays = Array(Weekday.allCases[1..<Weekday.allCases.count] + Weekday.allCases[0..<1])
    
    private let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let cardColors = [0xFD4C49, 0xFF881E, 0x007BFA, 0x6E44FE, 0x33CF69, 0xE66DD4,
                              0xF9D4D4, 0x34A7FE, 0x46E69D, 0x35347C, 0xFF674D, 0xFF99CC,
                              0xF6C48B, 0x7994F5, 0x832CF1, 0xAD56DA, 0x8D72E6, 0x2FD058
    ]
    
    private let collectionsSectionParams = GeometricParams(cellCount: 6,
                                                           leftInset: 18,
                                                           rightInset: 18,
                                                           topInset: 24,
                                                           bottomInset: 24,
                                                           cellSpacing: 0,
                                                           lineSpacing: 0)
    private let emojisCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let trackerType: TrackerType
    
    weak var delegate: TrackerCreationViewControllerDelegate?
    
    private lazy var trackerNameTextField = UITextField()
    private lazy var trackerNameLengthErrorLabel = UILabel()
    private lazy var trackerNameStackView = UIStackView()
    
    private lazy var cancelButton = UIButton()
    private lazy var addButton = UIButton()
    private lazy var buttonsStackView = UIStackView()
    
    private lazy var trackerCreationTableView = UITableView()
    private lazy var trackerCreationScrollView = UIScrollView()
    
    private var trackerCategory: String = ""
    
    private var schedule: [Weekday] = []
    private var trackerParameters: [(name: String, desc: String)] = [("Категория", ""), ("Расписание", "")]
    
    private var pickedColorIndex = -1
    
    private var CollectionsCellSize: Double {
        let availableWidth = view.frame.width - collectionsSectionParams.paddingWidth
        return availableWidth / CGFloat(collectionsSectionParams.cellCount)
    }
    
    
    private var pickedEmojiIndex = -1
    
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        trackerParameters[0].desc = trackerCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        setupNavigationItem()
        setupButtonsStackView()
        setupTrackerCreationScrollView()
    }
    
    private func setupNavigationItem() {
        switch trackerType {
        case .habit:
            navigationItem.title = "Новая привычка"
        case .nonregular:
            navigationItem.title = "Новое нерегулярное событие"
        }
        navigationItem.hidesBackButton = true
    }
    
    private func setupTrackerCreationScrollView() {
        setupTrackerNameStackView()
        setupTableView()
        setupEmojisCollectionView()
        setupColorsCollectionView()
        
        trackerCreationScrollView.scrollsToTop = true
        
        
        trackerCreationScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerCreationScrollView)
        trackerCreationScrollView.addSubview(trackerNameStackView)
        trackerCreationScrollView.addSubview(trackerCreationTableView)
        trackerCreationScrollView.addSubview(emojisCollectionView)
        trackerCreationScrollView.addSubview(colorsCollectionView)
        
        NSLayoutConstraint.activate([
            trackerCreationScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCreationScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCreationScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackerCreationScrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            trackerNameStackView.topAnchor.constraint(equalTo: trackerCreationScrollView.topAnchor, constant: 24),
            trackerNameStackView.leadingAnchor.constraint(equalTo: trackerCreationScrollView.leadingAnchor, constant: 16),
            trackerNameStackView.trailingAnchor.constraint(equalTo: trackerCreationScrollView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.widthAnchor.constraint(equalTo: trackerCreationScrollView.widthAnchor, constant: -32)
        ])
        
        
        var trackerCreationTableRowCount: CGFloat {
            if trackerType == .habit {
                return 2
            } else {
                return 1
            }
        }
        NSLayoutConstraint.activate([
            trackerCreationTableView.heightAnchor.constraint(equalToConstant: (trackerCreationTableView.rowHeight * trackerCreationTableRowCount) - 1),
            trackerCreationTableView.widthAnchor.constraint(equalTo: trackerCreationScrollView.widthAnchor, constant: -32),
            trackerCreationTableView.topAnchor.constraint(equalTo: trackerNameStackView.bottomAnchor, constant: 24),
            trackerCreationTableView.leadingAnchor.constraint(equalTo: trackerCreationScrollView.leadingAnchor, constant: 16),
            trackerCreationTableView.trailingAnchor.constraint(equalTo: trackerCreationScrollView.trailingAnchor, constant: -16)
            
        ])
        
        let emojisCollectionLinesCount = ceil(Double(cardColors.count / collectionsSectionParams.cellCount))
        let emojisCollectionHeight = (CollectionsCellSize * emojisCollectionLinesCount) + (emojisCollectionLinesCount - 1) + collectionsSectionParams.bottomInset + collectionsSectionParams.topInset + 23
        NSLayoutConstraint.activate([
            emojisCollectionView.topAnchor.constraint(equalTo: trackerCreationTableView.bottomAnchor, constant: 32),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: emojisCollectionHeight),
            emojisCollectionView.widthAnchor.constraint(equalTo: trackerCreationScrollView.widthAnchor)
            
        ])
        
        let colorsCollectionLinesCount = ceil(Double(cardColors.count / collectionsSectionParams.cellCount))
        let colorsCollectionHeight = (CollectionsCellSize * colorsCollectionLinesCount) + (colorsCollectionLinesCount - 1) + collectionsSectionParams.bottomInset + collectionsSectionParams.topInset + 23
        
        NSLayoutConstraint.activate([
            colorsCollectionView.leadingAnchor.constraint(equalTo: trackerCreationScrollView.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: trackerCreationScrollView.trailingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 16),
            colorsCollectionView.bottomAnchor.constraint(equalTo: trackerCreationScrollView.bottomAnchor),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: colorsCollectionHeight),
            colorsCollectionView.widthAnchor.constraint(equalTo: trackerCreationScrollView.widthAnchor)
        ])
        
    }
    
    private func setupTrackerNameStackView() {
        trackerNameStackView.axis = .vertical
        trackerNameStackView.spacing = 8
        
        trackerNameLengthErrorLabel.text = "Ограничение 38 символов"
        trackerNameLengthErrorLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameLengthErrorLabel.textColor = .trackerRed
        trackerNameLengthErrorLabel.textAlignment = .center
        trackerNameLengthErrorLabel.isHidden = true
        
        trackerNameTextField.delegate = self
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameTextField.clearButtonMode = .whileEditing
        trackerNameTextField.leftView = UIView(frame: CGRectMake(0, 0, 16, 0));
        trackerNameTextField.leftViewMode = .always
        trackerNameTextField.textColor = .trackerBlack
        trackerNameTextField.tintColor = .trackerBlue
        trackerNameTextField.backgroundColor = .trackerBackground
        trackerNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.trackerGray]
        )
        trackerNameTextField.layer.cornerRadius = 16.0
        trackerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        trackerNameStackView.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLengthErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        trackerNameStackView.addArrangedSubview(trackerNameTextField)
        trackerNameStackView.addArrangedSubview(trackerNameLengthErrorLabel)
    }
    
    private func setupTableView() {
        trackerCreationTableView.register(TrackerCreationTableViewCell.self, forCellReuseIdentifier: TrackerCreationTableViewCell.identifier)
        
        trackerCreationTableView.delegate = self
        trackerCreationTableView.dataSource = self
        
        trackerCreationTableView.separatorColor = .trackerGray
        trackerCreationTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        trackerCreationTableView.isScrollEnabled = false
        trackerCreationTableView.rowHeight = 75
        trackerCreationTableView.layer.cornerRadius = 16
        trackerCreationTableView.layer.masksToBounds = true
        trackerCreationTableView.tableHeaderView = UIView()
        
        trackerCreationTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupEmojisCollectionView() {
        emojisCollectionView.register(EmojisCollectionViewCell.self, forCellWithReuseIdentifier: EmojisCollectionViewCell.identifier)
        emojisCollectionView.register(EmojisCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojisCollectionHeaderView.identifier)
        emojisCollectionView.backgroundColor = .trackerWhite
        emojisCollectionView.isScrollEnabled = false
        
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = self
        
        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupColorsCollectionView() {
        colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.identifier)
        colorsCollectionView.register(ColorsCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ColorsCollectionHeaderView.identifier)
        
        colorsCollectionView.backgroundColor = .trackerWhite
        colorsCollectionView.isScrollEnabled = false
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtonsStackView() {
        cancelButton.setTitleColor(.trackerRed, for: .normal)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = .trackerWhite
        cancelButton.layer.cornerRadius = 16.0
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(resource: .trackerRed).cgColor
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        addButton.setTitleColor(.trackerWhite, for: .normal)
        addButton.setTitle("Создать", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.layer.cornerRadius = 16.0
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.backgroundColor = .trackerGray
        addButton.isEnabled = false
        
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func checkTrackerPropertiesNotSpecified() -> Bool{
        trackerNameTextField.text?.isEmpty ?? false ||
        trackerParameters[0].desc.isEmpty ||
        (trackerParameters[1].desc.isEmpty && trackerType == .habit) ||
        pickedColorIndex < 0 ||
        pickedEmojiIndex < 0
    }
    
    private func setupAddButton() {
        if checkTrackerPropertiesNotSpecified()
        {
            addButton.isEnabled = false
            addButton.backgroundColor = .trackerGray
        } else {
            addButton.isEnabled = true
            addButton.backgroundColor = .trackerBlack
        }
    }
    
    @objc
    private func didTapCancelButton() {
        navigationController?.dismiss(animated: false)
    }
    
    @objc
    private func didTapAddButton() {
        if let title = trackerNameTextField.text {
            delegate?.createTracker(Tracker(id: UUID(),
                                            title: title,
                                            color: UIColor(rgb: cardColors[pickedColorIndex]),
                                            emoji: emojis[pickedEmojiIndex],
                                            schedule: schedule),
                                    trackerCategory)
        }
        navigationController?.dismiss(animated: false)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        setupAddButton()
    }
}

extension TrackerCreationViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        trackerNameLengthErrorLabel.isHidden = newString.count <= maxLength
        
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackerCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoriesViewController = CategoriesViewController()
            let categoriesViewModel = CategoriesViewModel(pickedTitle: trackerParameters[0].desc)
            categoriesViewController.delegate = self
            categoriesViewController.categoriesViewModel = categoriesViewModel
            navigationController?.pushViewController(categoriesViewController, animated: true)
        }
        else if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.schedule = weekdays.map{($0, schedule.contains($0))}
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = (indexPath.row == trackerParameters.count - 1)
        ? UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension TrackerCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerParameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCreationTableViewCell.identifier, for: indexPath) as? TrackerCreationTableViewCell
        else {
            return TrackerCreationTableViewCell()
        }
        cell.trackerParameterName = trackerParameters[indexPath.row].name
        cell.trackerParameterDescription = trackerParameters[indexPath.row].desc
        
        return cell
    }
}

extension TrackerCreationViewController: ScheduleViewControllerDelegate {
    func updateScheduleInfo(_ weekdays: [Weekday]) {
        schedule = weekdays
        if weekdays.count == Weekday.allCases.count {
            trackerParameters[1].desc = "Каждый день"
        } else {
            trackerParameters[1].desc = weekdays.map{$0.shortname}.joined(separator: ", ")
        }
        trackerCreationTableView.reloadData()
        setupAddButton()
    }
}


extension TrackerCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorsCollectionView {
            return cardColors.count
        }
        else if collectionView == emojisCollectionView {
            return emojis.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.identifier, for: indexPath) as? ColorsCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.color = cardColors[indexPath.row]
            cell.isPicked = indexPath.row == pickedColorIndex
            
            return cell
        }
        else if  collectionView == emojisCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojisCollectionViewCell.identifier, for: indexPath) as? EmojisCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.emoji = emojis[indexPath.row]
            cell.isPicked = indexPath.row == pickedEmojiIndex
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == colorsCollectionView {
            var id: String
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                id = ColorsCollectionHeaderView.identifier
            default:
                id = ""
            }
            
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? ColorsCollectionHeaderView
            else {
                return UICollectionReusableView()
            }
            
            view.categoryTitle = "Цвет"
            return view
        }
        else if collectionView == emojisCollectionView {
            var id: String
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                id = EmojisCollectionHeaderView.identifier
            default:
                id = ""
            }
            
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EmojisCollectionHeaderView
            else {
                return UICollectionReusableView()
            }
            
            view.categoryTitle = "Emoji"
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView {
            pickedColorIndex = indexPath.row
            colorsCollectionView.reloadData()
            
        }
        else if collectionView == emojisCollectionView {
            pickedEmojiIndex = indexPath.row
            emojisCollectionView.reloadData()
        }
        setupAddButton()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension TrackerCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: CollectionsCellSize,
                      height: CollectionsCellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionsSectionParams.topInset, left: collectionsSectionParams.leftInset, bottom: collectionsSectionParams.bottomInset, right: collectionsSectionParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionsSectionParams.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionsSectionParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

extension TrackerCreationViewController: CategoriesViewControllerDelegate {
    func updateCategoryInfo(_ categoryTitle: String) {
        trackerCategory = categoryTitle
        trackerParameters[0].desc = categoryTitle
        
        trackerCreationTableView.reloadData()
        setupAddButton()
    }
    
}
