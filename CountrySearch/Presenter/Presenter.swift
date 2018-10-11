//
//  Presenter.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

protocol Presenter {
    func openAlertVCForError(_ alert: UIAlertController)
    
    func openCountriesVC(_ title: String, _ value: [CountryEntity]) 
}

