//
//  CountriesTableViewCell.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

class CountriesTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nativeNameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var countyData: CountryEntity? {
        didSet {
            if let data = countyData {
                nameLabel.text = data.name
                nativeNameLabel.text = data.nativeName
                updateImageViewWithImage(nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func updateImageViewWithImage(_ image: UIImage?) {
        if let image = image {
            flagImageView.image = image
            flagImageView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.flagImageView.alpha = 1.0
                self.activityIndicator.alpha = 0
            }, completion: { _ in
                self.activityIndicator.stopAnimating()
            })
        } else {
            flagImageView.image = nil
            flagImageView.alpha = 0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }
}
