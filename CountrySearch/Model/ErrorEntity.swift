//
//  ErrorEntity.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import ObjectMapper

protocol EntityCreatable {
    static func createEntity(_ dict: [String: Any], _ text: String) -> ErrorEntity
}

enum ErrorEntity: Error {
    case notFound
    case otherError(String)
    
    static func error(_ code: Int, _ message: String = "") -> ErrorEntity {
        switch code {
        case 404:
            return notFound
        default:
            return otherError(message)
        }
    }
}

extension ErrorEntity: CustomStringConvertible {
    var description: String {
        switch self {
        case .notFound:
            return "404 Not Found"
        case .otherError(let message):
            return message
        }
    }
}

extension ErrorEntity: EntityCreatable {
    static func createEntity(_ dict: [String : Any], _ text: String) -> ErrorEntity {
        guard let code = dict[MapperKey.status] as? Int,
            let message = dict[MapperKey.message] as? String else {
                return ErrorEntity.otherError(text)
        }
        
        return ErrorEntity.error(code, message)
    }
}
