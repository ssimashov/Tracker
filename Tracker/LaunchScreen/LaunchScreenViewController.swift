//
//  LaunchScreenViewController.swift
//  Tracker
//
//  Created by Sergey Simashov on 01.12.2024.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerBlue
        
        createLogo()
        switchToTabBarController()
    }
    
    private func createLogo() {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            window.rootViewController = TabBarViewController()
            window.makeKeyAndVisible()
        }
    }
}
