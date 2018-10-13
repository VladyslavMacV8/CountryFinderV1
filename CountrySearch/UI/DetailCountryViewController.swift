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
    @IBOutlet private weak var tableView: UITableView!
    
    private let detailView = DetailCountryView.instanciateFromNib()
    let viewModel: DetailCountryViewModelProtocol = DetailCountryViewModel()
    
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
        
        tableView.register(CountriesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupSignals() {
        viewModel.getBorderData().start { [weak self] (event) in
            switch event {
            case .completed:
                self?.tableView.tableHeaderView = self?.addHeaderForTableView()
                self?.tableView.reloadData()
            case .interrupted:
                self?.tableView.isScrollEnabled = false
                self?.addPlaceholder()
            default: break
            }
        }
    }
    
    private func addPlaceholder() {
        let placeholderImage = UIImageView()
        placeholderImage.image = UIImage(named: "no_data")
        placeholderImage.contentMode = .scaleAspectFit
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(placeholderImage)
        placeholderImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        placeholderImage.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        placeholderImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        placeholderImage.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
    }
    
    private func addHeaderForTableView() -> UILabel {
        let label = UILabel()
        label.text = "   Borders"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.frame.size = CGSize(width: view.frame.width, height: view.frame.height / 15)
        return label
    }
}

extension DetailCountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.borderCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountriesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.countryData = viewModel.borderCountries[indexPath.row]
        return cell
    }
}

extension DetailCountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 9
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CountriesTableViewCell else { return }
        
        if let imageFromCache = flagImageCache.object(forKey: viewModel.borderCountries[indexPath.row].flag as NSString) {
            cell.updateImageViewWithImage(imageFromCache)
            return
        }
        
        let imageProvider = CacheFlagImageProvider(viewModel.borderCountries[indexPath.row]) { (image) in
            OperationQueue.main.addOperation {
                cell.updateImageViewWithImage(image)
            }
        }
        viewModel.imageProviders.insert(imageProvider)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CountriesTableViewCell else { return }
        for provider in viewModel.imageProviders.filter({ $0.country == cell.countryData }) {
            provider.cancel()
            viewModel.imageProviders.remove(provider)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getSelectedCountry(viewModel.borderCountries[indexPath.row])
    }
}
