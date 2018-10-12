//
//  UIAlertExtension.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

func showAlertMessage(title: String?, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
}

func showCustomError(error: ErrorEntity) -> UIAlertController {
    let alert = UIAlertController(title: "", message: error.description, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { action in
        alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    return alert
}

func showAlertMessage(title: String?, message: String, completition: (() -> ())?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        completition?()
    }))
    alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil));
    return alert
}

