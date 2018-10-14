//
//  CountriesViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ReactiveSwift
import ObjectMapper

protocol CountriesViewModelProtocol: class {
    var countries: [CountryEntity] { get set }
    var imageProviders: Set<CacheFlagImageProvider> { get set }
    
    func getSelectedCountry(_ value: CountryEntity)
    func searchCountry(_ name: String) -> SignalProducer<(), ErrorEntity>
}

class CountriesViewModel: GeneralViewModel, CountriesViewModelProtocol {
    var countries = [CountryEntity]()
    var imageProviders: Set<CacheFlagImageProvider> = []
    
    func getSelectedCountry(_ value: CountryEntity) {
        presenter.openDetailVC(value)
    }
    
    func searchCountry(_ name: String) -> SignalProducer<(), ErrorEntity> {
        return SignalProducer { [weak self] observer, _ in
            networkProvider.request(.byName(name), completion: { (result) in
                processing(observer: observer, result: result, closure: { (json) in
                    guard let arrayJson = json as? [[String: AnyObject]] else { return }
                    self?.countries = Mapper<CountryEntity>().mapArray(JSONArray: arrayJson)
                })
            })
        }
    }
}


