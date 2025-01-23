//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 19.01.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    private let userDefaults = UserDefaults.standard
    
    private lazy var pages: [UIViewController] = {
        let first = UIViewController()
        setupOnboardingFirstPage(view: first.view)
        
        let second = UIViewController()
        setupOnboardingSecondPage(view: second.view)
        
        return [first, second]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerBlack.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    private lazy var continueButton = UIButton()
    
    override init(
        transitionStyle: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]?
    ) {
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupContinueButton()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupContinueButton() {
        continueButton.setTitleColor(.trackerWhite, for: .normal)
        continueButton.setTitle(NSLocalizedString("onboarding.button", comment: ""), for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        continueButton.layer.cornerRadius = 16.0
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        continueButton.backgroundColor = .trackerBlack
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupOnboardingFirstPage(view: UIView) {
        let backroundImageView = UIImageView()
        let backgroundImage = UIImage(resource: .firstPageBackground)
        backroundImageView.image = backgroundImage
        backroundImageView.contentMode = .scaleAspectFill
        
        let label = UILabel()
        label.text = NSLocalizedString("onboarding.first", comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        
        backroundImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backroundImageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            backroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304)
        ])
    }
    
    private func setupOnboardingSecondPage(view: UIView) {
        let backroundImageView = UIImageView()
        let backgroundImage = UIImage(resource: .secondPageBackground)
        backroundImageView.image = backgroundImage
        backroundImageView.contentMode = .scaleAspectFill
        
        let label = UILabel()
        label.text = NSLocalizedString("onboarding.second", comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        
        backroundImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backroundImageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            backroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304)
        ])
    }
    
    @objc
    func didTapContinueButton() {
        userDefaults.set(true, forKey: "isOnboardingSkipped")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = TabBarViewController()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}


extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
