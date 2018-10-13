//
//  CountryEntity.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ObjectMapper
import RealmSwift

class CountryEntity: Object, StaticMappable {
    @objc dynamic var flag        = ""
    @objc dynamic var name        = ""
    @objc dynamic var nativeName  = ""
    var coordinates = [Double]()
    var borders     = [String]()
    var currencies  = [CurrencyCountryEntity]()
    var languages   = [LanguageCountryEntity]()
    
    func mapping(map: Map) {
        flag        <- map[MapperKey.flag]
        name        <- map[MapperKey.name]
        nativeName  <- map[MapperKey.nativeName]
        coordinates <- map[MapperKey.latlng]
        borders     <- map[MapperKey.borders]
        currencies  <- map[MapperKey.currencies]
        languages   <- map[MapperKey.languages]
    }
    
    override class func primaryKey() -> String? {
        return "flag"
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return CountryEntity()
    }
}

class CurrencyCountryEntity: Object, StaticMappable {
    @objc dynamic var name            = ""
    @objc dynamic private var code    = ""
    
    func mapping(map: Map) {
        name <- map[MapperKey.name]
        code <- map[MapperKey.code]
    }
    
    override class func primaryKey() -> String? {
        return "code"
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return CurrencyCountryEntity()
    }
}

class LanguageCountryEntity: Object, StaticMappable {
    @objc dynamic var name        = ""
    @objc dynamic private var iso = ""
    
    func mapping(map: Map) {
        name    <- map[MapperKey.name]
        iso     <- map[MapperKey.iso]
    }
    
    override class func primaryKey() -> String? {
        return "iso"
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return LanguageCountryEntity()
    }
}
