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
        
        let searchVC = SearchViewController.instantiate(from: .Main)
        searchVC.title = "Search countries"
        let secondNC = CustomNavigationController(rootViewController: searchVC)
        secondNC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let dbVC = CountriesViewController.instantiate(from: .Main)
        dbVC.state = .db
        dbVC.title = "Saved countries"
        let thirdNC = CustomNavigationController(rootViewController: dbVC)
        thirdNC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        viewControllers = [firstNC, secondNC, thirdNC]
    }
}
