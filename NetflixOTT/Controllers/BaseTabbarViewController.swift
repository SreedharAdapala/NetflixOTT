//
//  BaseTabbarViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 22/02/24.
//

import UIKit

class BaseTabbarViewController: UITabBarController {
    
//    private var traitObserver: NSObjectProtocol?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        observeTraitChanges()
//    }
//
//    deinit {
//        removeTraitObserver()
//    }
//
//    private func observeTraitChanges() {
//        traitObserver = NotificationCenter.default.addObserver(
//            forName: UIScreen.modeDidChangeNotification,
//            object: nil,
//            queue: OperationQueue.main
//        ) { [weak self] _ in
//            self?.updateTabBarVisibility()
//        }
//    }
//
//    private func removeTraitObserver() {
//        if let observer = traitObserver {
//            NotificationCenter.default.removeObserver(observer)
//        }
//    }
//
//    func updateTabBarVisibility() {
//        if UIScreen.main.traitCollection.verticalSizeClass == .compact {
//            // Landscape mode
//            tabBar.isHidden = true
//        } else {
//            // Portrait or other size classes
//            tabBar.isHidden = false
//        }
//    }
}
