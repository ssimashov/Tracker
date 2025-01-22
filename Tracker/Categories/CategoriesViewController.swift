//
//  CategoriesViewController..swift
//  Tracker
//
//  Created by Sergey Simashov on 20.01.2025.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func updateCategoryInfo(_ categoryTitle: String)
}

final class CategoriesViewController: UIViewController {
    weak var delegate: CategoriesViewControllerDelegate?
    
    private let categoriesTableView = UITableView(frame: .zero, style: .plain)
    private let addCategoryButton = UIButton()
    
    private let placeHolderImageView = UIImageView()
    private let placeHolderLabel = UILabel()
    private let placeHolderView = UIView()
    
    var categoriesViewModel: CategoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        
        bind()
        
        setupAddCategoryButton()
        setupTableView()
        setupPlugView()
    }
    
    private func bind() {
        guard let categoriesViewModel else { return }
        categoriesViewModel.onSelectCategory = { [weak self] category in
            self?.categoriesTableView.reloadData()
            self?.delegate?.updateCategoryInfo(category)
            self?.navigationController?.popViewController(animated: true)
        }
        
        categoriesViewModel.onAddCategory = { [weak self] _ in
            self?.categoriesTableView.reloadData()
        }
    }
    
    private func setupTableView() {
        categoriesTableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.rowHeight = 75
        categoriesTableView.layer.cornerRadius = 16
        categoriesTableView.layer.masksToBounds = true
        categoriesTableView.tableHeaderView = UIView()
        
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoriesTableView)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.setTitleColor(.trackerWhite, for: .normal)
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.backgroundColor = .trackerBlack
        addCategoryButton.layer.cornerRadius = 16.0
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPlugView() {
        let placeHolderImage = UIImage(resource: .placeHolderLogo)
        placeHolderImageView.image = placeHolderImage
        
        placeHolderLabel.text = "Привычки и события можно\nобъединить по смыслу"
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeHolderLabel.textAlignment = .center
        placeHolderLabel.numberOfLines = 2
        
        placeHolderView.isHidden = !(categoriesViewModel?.categories ?? []).isEmpty
        
        view.addSubview(placeHolderView)
        placeHolderView.addSubview(placeHolderImageView)
        placeHolderView.addSubview(placeHolderLabel)
        
        placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderView.centerYAnchor.constraint(equalTo: categoriesTableView.centerYAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeHolderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.topAnchor.constraint(equalTo: placeHolderView.topAnchor),
            placeHolderImageView.centerXAnchor.constraint(equalTo: placeHolderView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderLabel.heightAnchor.constraint(equalToConstant: 36),
            placeHolderLabel.bottomAnchor.constraint(equalTo: placeHolderView.bottomAnchor),
            placeHolderLabel.leadingAnchor.constraint(equalTo: placeHolderView.leadingAnchor),
            placeHolderLabel.trailingAnchor.constraint(equalTo: placeHolderView.trailingAnchor)
        ])
    }
    
    @objc
    private func didTapAddCategoryButton() {
        let categoryEditingViewController = CategoryEditingViewController()
        categoryEditingViewController.delegate = self
        navigationController?.pushViewController(categoryEditingViewController, animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesViewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as? CategoriesTableViewCell,
              let categoriesViewModel = categoriesViewModel
                
        else {
            return CategoriesTableViewCell()
        }
        
        cell.categoryTitle = categoriesViewModel.categories[indexPath.row]
        cell.isPicked = categoriesViewModel.pickedCategoryIndex == indexPath.row
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoriesViewModel?.selectCategory(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let categoriesViewModel = categoriesViewModel else { return }
        if indexPath.row == categoriesViewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 0
        }
    }
}

extension CategoriesViewController: CategoryEditingViewControllerDelegate {
    func addCategory(title: String) {
        categoriesViewModel?.addCategory(categoryTitle: title)
        placeHolderView.isHidden = !(categoriesViewModel?.categories ?? []).isEmpty
    }
}
