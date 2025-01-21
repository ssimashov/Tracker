//
//  CategoryEditingViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 20.01.2025.
//

import UIKit

protocol CategoryEditingViewControllerDelegate: AnyObject {
    func addCategory(title: String)
}

final class CategoryEditingViewController: UIViewController {
    weak var delegate: CategoryEditingViewControllerDelegate?
    private let categoryNameTextField = UITextField()
    private let completeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        setupNavigationItem()
        setupCompleteButton()
        setupCategoryNameTextField()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Новая категория"
        navigationItem.hidesBackButton = true
    }
    
    private func setupCategoryNameTextField() {
        categoryNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        categoryNameTextField.clearButtonMode = .whileEditing
        categoryNameTextField.leftView = UIView(frame: CGRectMake(0, 0, 16, 0));
        categoryNameTextField.leftViewMode = .always
        categoryNameTextField.textColor = .trackerBlack
        categoryNameTextField.tintColor = .trackerBlue
        categoryNameTextField.backgroundColor = .trackerBackground
        categoryNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.trackerGray]
        )
        categoryNameTextField.layer.cornerRadius = 16.0
        categoryNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true
        {
            completeButton.isEnabled = false
            completeButton.backgroundColor = .trackerGray
        } else {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .trackerBlack
        }
    }
    
    private func setupCompleteButton() {
        completeButton.setTitleColor(.trackerWhite, for: .normal)
        completeButton.setTitle("Готово", for: .normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeButton.layer.cornerRadius = 16.0
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        completeButton.backgroundColor = .trackerGray
        completeButton.isEnabled = false
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc
    private func didTapCompleteButton() {
        guard let text = categoryNameTextField.text?.capitalized else {
            navigationController?.popViewController(animated: false)
            return
        }
        delegate?.addCategory(title: text)
        navigationController?.popViewController(animated: false)
    }
}
