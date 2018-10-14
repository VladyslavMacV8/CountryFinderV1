//
//  Router.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class RouterImpl: Router {
    
    private(set) weak var rootController: CustomTabBarController?
    
    init(rootController: CustomTabBarController) {
        self.rootController = rootController
    }
    
    func present(controller: UIViewController?, animated: Bool, completition: RouterHandler) {
        guard let controller = controller else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.present(controller, animated: animated, completion: completition)
        }
    }
    
    func push(controller: UIViewController?, animated: Bool) {
        guard let controller = controller else { return }
        navigationRootViewController()?.pushViewController(controller, animated: animated)
    }
    

    func popController(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.popViewController(animated: animated)
        }
    }

    func popController(to number: Int, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            if let viewControllers: [UIViewController] = self?.navigationRootViewController()?.viewControllers {
                self?.navigationRootViewController()?.popToViewController(viewControllers[viewControllers.count - number], animated: animated)
            }
        }
    }
    
    func dismissController(animated: Bool, completition: RouterHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationRootViewController()?.dismiss(animated: animated, completion: completition)
        }
    }
    
    func navigationRootViewController() -> UINavigationController? {
        guard let navigationRootViewController = UIApplication.topViewController()?.navigationController as? CustomNavigationController else { return nil }
        return navigationRootViewController
    }

    func openAlertViewController(alertViewController: UIAlertController) {
        if let viewController = UIApplication.topViewController() {
            viewController.present(alertViewController, animated: true, completion:nil)
        }
    }
}
