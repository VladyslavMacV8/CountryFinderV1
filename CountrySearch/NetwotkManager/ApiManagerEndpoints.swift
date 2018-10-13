//
//  APIManager.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Wezom Mobile. All rights reserved.
//

import Moya

let endpointClosure = {(target: ApiManager) -> Endpoint in
    
    var httpFields = [String: String]()
    httpFields["Content-Type"] = "application/json"
    httpFields["accept"] = "application/json"
    
    let endpoint: Endpoint = Endpoint(url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                                      sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                      method: target.method,
                                      task: target.parameters,
                                      httpHeaderFields: httpFields)
    
    return endpoint
}

enum ApiManagerKey {
    static let codes = "codes"
    
}
