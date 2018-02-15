//
//  MainTabBarController.swift
//  Nasa
//
//  Created by 최동호 on 2018. 2. 12..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.black
        let viewController = ViewController()
        let dateViewController = DateViewController()
        let viewControllerList = [viewController, dateViewController]
        viewControllers = viewControllerList.map {
            UINavigationController(rootViewController: $0)
        }
        self.tabBar.items![0].title = "Today View"
        self.tabBar.items![1].title = "Date View"
    }


}
