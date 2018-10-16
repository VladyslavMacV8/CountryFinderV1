//
//  Constants.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import Foundation

enum Constants {
    static let baseURL = "https://restcountries.eu/rest/v2"
}

enum MapperKey {
    static let status       = "status"
    
    static let code         = "code"
    static let message      = "message"
    
    static let flag         = "flag"
    static let name         = "name"
    static let nativeName   = "nativeName"
    static let latlng       = "latlng"
    static let borders      = "borders"
    static let languages    = "languages"
    static let iso          = "iso639_2"
    static let currencies   = "currencies"
    static let alphaCode    = "alpha3Code"
}

enum CountryVCState {
    case net
    case db
}

enum CrashFlag {
    static let shn = "shn"
    static let stp = "stp"
}
