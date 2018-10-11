//
//  Presenter.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class PresenterImpl: Presenter {
    
    private let storyboard = AppStoryboard.Main.instance
    private let router: Router
    
    init() {
        guard let topController = UIApplication.topNavigationViewController() else {
            fatalError("Could not init stack")
        }
        
        router = RouterImpl(rootController: topController as! CustomNavigationController)
    }
    
    func openAlertVCForError(_ alert: UIAlertController) {
        router.openAlertViewController(alertViewController: alert)
    }
    
    func openCountriesVC(_ title: String, _ value: [CountryEntity]) {
        let vc = CountriesViewController.instantiate(from: .Main)
        vc.title = title
        vc.viewModel.countries = value
        router.push(controller: vc, animated: true)
    }
}
