//
//  DetailCountryViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/13/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ReactiveSwift
import ObjectMapper

protocol DetailCountryViewModelProtocol: class {
    var country: CountryEntity { get set }
    var borderCountries: [CountryEntity] { get }
    var imageProviders: Set<CacheFlagImageProvider> { get set }
    
    func getBorderData() -> SignalProducer<(), ErrorEntity>
    func getSelectedCountry(_ value: CountryEntity)
}

class DetailCountryViewModel: GeneralViewModel, DetailCountryViewModelProtocol {
    var country = CountryEntity()
    var borderCountries = [CountryEntity]()
    var imageProviders: Set<CacheFlagImageProvider> = []
    
    func getBorderData() -> SignalProducer<(), ErrorEntity> {
        let codes = country.borders.joined(separator: ";")
        return SignalProducer { [weak self] observer, _ in
            guard !codes.isEmpty else {
                observer.sendInterrupted()
                return
            }
            networkProvider.request(.byCode(codes), completion: { (result) in
                processing(observer: observer, result: result, closure: { (json) in
                    guard let arrayJson = json as? [[String: AnyObject]] else { return }
                    self?.borderCountries = Mapper<CountryEntity>().mapArray(JSONArray: arrayJson)
                })
            })
        }
    }
    
    func getSelectedCountry(_ value: CountryEntity) {
        presenter.openDetailVC(value)
    }
}
