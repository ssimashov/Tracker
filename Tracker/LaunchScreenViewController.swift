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
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
}
