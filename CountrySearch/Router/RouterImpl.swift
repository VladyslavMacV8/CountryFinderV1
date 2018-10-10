//
//  Router.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class RouterImpl: Router {
    
    private(set) weak var rootController: CustomNavigationController?
    
    init(rootController: CustomNavigationController) {
        self.rootController = rootController
    }
    
    func present(controller: UIViewController?) {
        present(controller: controller, animated: true)
    }
    
    func present(controller: UIViewController?, animated: Bool) {
        guard let controller = controller else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.present(controller, animated: animated, completion: nil)
        }
    }
    
    func present(controller: UIViewController?, animated: Bool, completition: @escaping RouterHandler) {
        guard let controller = controller else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.present(controller, animated: animated, completion: completition)
        }
    }
    
    func push(controller: UIViewController?) {
        push(controller: controller, animated: true)
    }
    
    func push(controller: UIViewController?, animated: Bool) {
        guard let controller = controller else { return }
        
        navigationRootViewController()?.pushViewController(controller, animated: true)
    }
    
    func popController() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            _ = self?.navigationRootViewController()?.popViewController(animated: false)
        }
    }
    
    func popController(animated: Bool ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            _ = self?.navigationRootViewController()?.popViewController(animated: animated)
        }
    }
    
    func popBack(_ nb: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            if let viewControllers: [UIViewController] = self?.navigationRootViewController()?.viewControllers {
                self?.navigationRootViewController()?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            }
        }
    }
    
    func dismissController() {
        dismissController(animated: true)
    }
    
    func dismissController(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.dismiss(animated: animated, completion: nil)
        }
    }
    
    
    func dismissController(animated: Bool, completition: @escaping RouterHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.dismiss(animated: animated, completion: completition)
        }
    }
    
    func navigationRootViewController() -> UINavigationController? {
        
        guard let containerViewController = UIApplication.topViewController() else {
            return self.rootController
        }
        
        if let navigationController = containerViewController.navigationController as? CustomNavigationController {
            return navigationController
        }
        
        return nil
    }
    
    func getRoot() -> CustomNavigationController? {
        return rootController
    }
    
    func popToRootViewController(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            _ = self?.navigationRootViewController()?.popToRootViewController(animated: animated)
        }
    }
    
    func pushVCToRoot(viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            _ = self?.navigationRootViewController()?.popToRootViewController(animated: animated)
            self?.push(controller: viewController)
        }
    }
    
    func openAlertViewController(alertViewController: UIAlertController) {
        if let viewController = UIApplication.topViewController() {
            viewController.present(alertViewController, animated: true, completion:nil)
        }
    }
    
    func changeRootViewController(controller: UIViewController) {
        if let containerVC = UIApplication.topViewController() {
            containerVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func setAsRootVC(viewController: UIViewController) {
        let navigationVC = CustomNavigationController(rootViewController: viewController)
        navigationVC.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
}
