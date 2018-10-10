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
    
    func getRegionData(_ region: String) -> SignalProducer<(), NoError>
}

class MainViewModel: GeneralViewModel, MainViewModelProtocol {
    
    let regions = ["Africa", "Americas", "Asia", "Europe", "Oceania"]
    
    var countres = [CountryEntity]()
    
    func getRegionData(_ region: String) -> SignalProducer<(), NoError> {
        return SignalProducer { [weak self] observer, _ in
            networkProvider.request(.byRegion(region), completion: { (result) in
                processing(observer: observer, result: result, closure: { (arrayJson) in
                    self?.countres = Mapper<CountryEntity>().mapArray(JSONArray: arrayJson)
                })
            })
        }
    }
}
