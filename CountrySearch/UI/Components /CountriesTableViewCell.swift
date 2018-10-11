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
    
    private let placeholder = UIImage(named: "Flag_placeholder")

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = flagImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagImageView.image = placeholder
    }

    func update(_ country: CountryEntity) {
        DispatchQueue.global().async {
            let svg = SVGKImage(contentsOf: URL(string: country.flag))?.uiImage
            DispatchQueue.main.async { [weak self] in
                self?.flagImageView.image = svg
            }
        }
        
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
    }
    
}
