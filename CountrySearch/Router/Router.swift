//
//  Router.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import Foundation

import UIKit

typealias RouterHandler = () -> Void

protocol Router: class {
    
    var rootController: CustomNavigationController? { get }
    
    func present(controller: UIViewController?)
    func present(controller: UIViewController?, animated: Bool)
    func present(controller: UIViewController?, animated: Bool, completition: @escaping RouterHandler)
    
    func push(controller: UIViewController?)
    func push(controller: UIViewController?, animated: Bool)
    
    func popController()
    func popController(animated: Bool)
    func popBack(_ nb: Int)
    
    func dismissController()
    func dismissController(animated: Bool)
    func dismissController(animated: Bool, completition: @escaping RouterHandler)
    
    func getRoot() -> CustomNavigationController?
    
    func popToRootViewController(animated: Bool)
    
    func pushVCToRoot(viewController: UIViewController, animated: Bool)
    
    func openAlertViewController(alertViewController: UIAlertController)
    
    func changeRootViewController(controller: UIViewController)
    func setAsRootVC(viewController: UIViewController)
}
