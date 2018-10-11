//
//  CountriesViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ReactiveSwift

protocol CountriesViewModelProtocol: class {
    var countries: [CountryEntity] { get set }
}

class CountriesViewModel: GeneralViewModel, CountriesViewModelProtocol {
    var countries = [CountryEntity]()
    
    
}
