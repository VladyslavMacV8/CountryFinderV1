//
//  CountryEntity.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ObjectMapper

class CountryEntity: Mappable {
    
    var name = ""
    var nativeName = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map[MapperKey.name]
        nativeName <- map[MapperKey.name]
    }
}
