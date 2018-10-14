//
//  CustomTabBarController.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/14/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstNC = CustomNavigationController(rootViewController: MainViewController.instantiate(from: .Main))
        firstNC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        let secondNC = CustomNavigationController(rootViewController: SearchViewController.instantiate(from: .Main))
        secondNC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
//        let thirdNC = CustomNavigationController(rootViewController: CountriesViewController.instantiate(from: .Main))
//        thirdNC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        viewControllers = [firstNC, secondNC]
    }
}
