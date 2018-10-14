//
//  Router.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import Foundation

import UIKit

typealias RouterHandler = (() -> ())?

protocol Router: class {
    
    var rootController: CustomTabBarController? { get }
    
    func present(controller: UIViewController?, animated: Bool, completition: RouterHandler)
    func push(controller: UIViewController?, animated: Bool)
    func popController(animated: Bool)
    func popController(to number: Int, animated: Bool)
    func dismissController(animated: Bool, completition: RouterHandler)

    func openAlertViewController(alertViewController: UIAlertController)
}
