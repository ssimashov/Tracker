//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 01.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private enum TabBarItem: String {
        case trackers = "Трекеры"
        case statistics = "Статистика"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
        setTabBarAppearance()
    }
    
    private func createTabBar() {
        
        viewControllers = [
            createTabBarItem(
                viewController: TrackersViewController(),
                title: TabBarItem.trackers.rawValue,
                image: UIImage(named:"trackers")
            ),
            createTabBarItem(
                viewController: StatisticsViewController(),
                title: TabBarItem.statistics.rawValue,
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
