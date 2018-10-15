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
    
    func getSelectedCountry(_ value: CountryEntity, _ state: CountryVCState)
    func searchCountry(_ name: String) -> SignalProducer<(), ErrorEntity>
    func getCountryFromDB() -> SignalProducer<(), ErrorEntity>
}

class CountriesViewModel: GeneralViewModel, CountriesViewModelProtocol {
    var countries = [CountryEntity]()
    var imageProviders: Set<CacheFlagImageProvider> = []
    
    func getSelectedCountry(_ value: CountryEntity, _ state: CountryVCState) {
        presenter.openDetailVC(value, state)
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
    
    func getCountryFromDB() -> SignalProducer<(), ErrorEntity> {
        countries.removeAll()
        
        return SignalProducer { [weak self] observer, _ in
            guard let entity = self?.getDataFromArray(CountryEntity.self) else {
                observer.sendInterrupted()
                return
            }
            guard let array = Array(entity) as? [CountryEntity] else {
                observer.sendInterrupted()
                return
            }
            
            if array.count == 0 {
                observer.sendInterrupted()
                return
            }
            
            let code = array.map { String($0.alphaCode) }.joined(separator: ";")
            
            if array.count < 2 {
                networkProvider.request(.byCode(code), completion: { (result) in
                    processing(observer: observer, result: result, closure: { (json) in
                        guard let json = json as? [String: AnyObject] else { return }
                        guard let value = Mapper<CountryEntity>().map(JSON: json) else { return }
                        self?.countries.append(value)
                    })
                })
            } else {
                networkProvider.request(.byCodes(code), completion: { (result) in
                    processing(observer: observer, result: result, closure: { (json) in
                        guard let arrayJson = json as? [[String: AnyObject]] else { return }
                        self?.countries = Mapper<CountryEntity>().mapArray(JSONArray: arrayJson)
                    })
                })
            }
        }
    }
}


