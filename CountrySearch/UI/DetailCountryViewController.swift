//
//  DetailCountryViewController.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/13/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

class DetailCountryViewController: UIViewController {
    
    @IBOutlet private weak var headView: UIView!
    @IBOutlet private weak var borderCountriesButton: UIButton!
    
    private let barButton = UIBarButtonItem()
    private let detailView = DetailCountryView.instanciateFromNib()
    let viewModel: DetailCountryViewModelProtocol = DetailCountryViewModel()
    var state: CountryVCState = .net
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSignals()
    }
    
    private func setupViews() {
        detailView.configData(viewModel.country)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        headView.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: headView.topAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: headView.bottomAnchor).isActive = true
        detailView.leadingAnchor.constraint(equalTo: headView.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: headView.trailingAnchor).isActive = true
        
        borderCountriesButton.clipsToBounds = true
        borderCountriesButton.layer.cornerRadius = 5
        borderCountriesButton.addTarget(self, action: #selector(borderCountriesAction), for: .touchUpInside)
    }
    
    private func setupSignals() {
        viewModel.getBorderData().start { [weak self] (event) in
            switch event {
            case .completed:
                self?.borderCountriesButton.isEnabled = true
                self?.addPlaceholder("There are available border countries")
                self?.setupBarButton()
            case .interrupted:
                self?.addPlaceholder("There are no border countries")
            default: break
            }
        }
    }
    
    private func addPlaceholder(_ title: String) {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: headView.bottomAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: borderCountriesButton.topAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupBarButton() {
        barButton.style = .done
        barButton.target = self
        barButton.action = #selector(countryAction)
        
        if state == .net {
            barButton.title = "Save"
            barButton.isEnabled = !viewModel.isContainsCountry()
        } else {
            barButton.title = "Delete"
        }
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func borderCountriesAction() {
        viewModel.openBorderCountryiesVC()
    }
    
    @objc private func countryAction() {
        if state == .net {
            viewModel.saveCountryToBD()
            barButton.isEnabled = !viewModel.isContainsCountry()
        } else {
            viewModel.deleteCountryFromDB()
        }
    }
}

