//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 01.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        setTabBarAppearance()
    }
    
    private func createTabBar() {
        
        let navigationViewController = UINavigationController(rootViewController: TrackersViewController())
        
        viewControllers = [
            createTabBarItem(
                viewController: navigationViewController,
                title: NSLocalizedString("trackers", comment: ""),
                image: UIImage(named:"trackers")
            ),
            createTabBarItem(
                viewController: StatisticsViewController(),
                title: NSLocalizedString("statistics", comment: ""),
                image: UIImage(named:"statistics")
            )
        ]
    }
    
    private func setTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.clipsToBounds = true
    }
    
    private func createTabBarItem(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
    }
}
