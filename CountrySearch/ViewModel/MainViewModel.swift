//
//  MainViewModel.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ReactiveSwift
import Result
import ObjectMapper

protocol MainViewModelProtocol: class {
    var regions: [String] { get }
    
    func getRegionData(_ region: String) -> SignalProducer<(), ErrorEntity>
}

class MainViewModel: GeneralViewModel, MainViewModelProtocol {
    
    let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    
    func getRegionData(_ region: String) -> SignalProducer<(), ErrorEntity> {
        return SignalProducer { [weak self] observer, _ in
            networkProvider.request(.byRegion(region.lowercased()), completion: { (result) in
                processing(observer: observer, result: result, closure: { (json) in
                    guard let arrayJson = json as? [[String: AnyObject]] else { return }
                    self?.presenter.openCountriesVC(region, Mapper<CountryEntity>().mapArray(JSONArray: arrayJson))
                })
            })
        }
    }
}
