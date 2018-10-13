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
    var imageProviders: Set<CacheFlagImageProvider> { get set }
    
    func getSelectedCountry(_ value: CountryEntity)
}

class CountriesViewModel: GeneralViewModel, CountriesViewModelProtocol {
    var countries = [CountryEntity]()
    var imageProviders: Set<CacheFlagImageProvider> = []
    
    func getSelectedCountry(_ value: CountryEntity) {
        presenter.openDetailVC(value)
    }
}


