//
//  NonregularTrackerCreationViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 17.12.2024.
//

import UIKit

final class NonreglarTrackerCreationViewController: UIViewController {
    weak var delegate: TrackerCreationViewControllerDelegate?
    
    private lazy var cancelButton = UIButton()
    private lazy var addButton = UIButton()
    private lazy var buttonsStackView = UIStackView()
    private lazy var trackerNameTextField = UITextField()
    private lazy var trackerNameLengthErrorLabel = UILabel()
    private lazy var trackerNameStackView = UIStackView()
    private lazy var trackerCreationTableView = UITableView()
    
    private let trackerCategory = "Нерегулярная категория"
    private var schedule: [Weekday] = []
    private var trackerParameters: [(name: String, desc: String)] = [("Категория", "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerParameters[0].desc = trackerCategory
        navigationItem.title = "Новое нерегулярное событие"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .trackerWhite
        setupTrackerNameStackView()
        setupButtonsStackView()
        setupTableView()
    }
    
    private func setupTableView() {
        trackerCreationTableView.register(TrackerCreationTableViewCell.self, forCellReuseIdentifier: TrackerCreationTableViewCell.identifier)
        
        trackerCreationTableView.delegate = self
        trackerCreationTableView.dataSource = self
        
        trackerCreationTableView.separatorColor = .trackerGray
        trackerCreationTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        trackerCreationTableView.separatorStyle = .none
        
        trackerCreationTableView.rowHeight = 75
        trackerCreationTableView.layer.cornerRadius = 16
        trackerCreationTableView.layer.masksToBounds = true
        trackerCreationTableView.tableHeaderView = UIView()
        
        trackerCreationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerCreationTableView)
        
        NSLayoutConstraint.activate([
            trackerCreationTableView.heightAnchor.constraint(equalToConstant: 75),
            trackerCreationTableView.topAnchor.constraint(equalTo: trackerNameStackView.bottomAnchor, constant: 24),
            trackerCreationTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCreationTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
        view.addSubview(trackerNameStackView)
        
        NSLayoutConstraint.activate([
            trackerNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
        ])
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
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAddButton() {
        if trackerNameTextField.text?.isEmpty ?? false || trackerParameters[0].desc.isEmpty {
            addButton.isEnabled = false
            addButton.backgroundColor = .trackerGray
        } else {
            addButton.isEnabled = true
            addButton.backgroundColor = .trackerBlack
        }
    }
    
    @objc
    private func didTapCancelButton() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc
    private func didTapAddButton() {
        if let title = trackerNameTextField.text {
            delegate?.createTracker(Tracker(id: UUID(),
                                            title: title,
                                            color: .trackerRed,
                                            emoji: "❤️",
                                            schedule: schedule),
                                    trackerCategory)
        }
        navigationController?.dismiss(animated: true)
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        setupAddButton()
    }
}

extension NonreglarTrackerCreationViewController: UITextFieldDelegate{
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


extension NonreglarTrackerCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


extension NonreglarTrackerCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerParameters.count
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
