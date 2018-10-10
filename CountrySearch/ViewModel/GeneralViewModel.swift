//
//  GeneralViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import Foundation

protocol GeneralViewModelProtocol: class {
    var presenter: Presenter { get }
    
    func configureSignals()
}

class GeneralViewModel: GeneralViewModelProtocol {
    
    lazy var presenter: Presenter = PresenterImpl()
    
    init() {
        configureSignals()
    }
    
    func configureSignals() {}
}
