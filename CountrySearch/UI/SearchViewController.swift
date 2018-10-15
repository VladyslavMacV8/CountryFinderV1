//
//  SearchViewController.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/14/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: CountriesViewModelProtocol = CountriesViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        tableView.register(CountriesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func callSignals() {
        guard let text = searchController.searchBar.text else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading countries"
        hud.show(in: view, animated: true)
        
        viewModel.searchCountry(text).start { [weak self] (event) in
            hud.dismiss(animated: true)
            switch event {
            case .completed:
                self?.tableView.reloadData()
            default: break
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountriesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.countryData = viewModel.countries[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 9
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CountriesTableViewCell else { return }
        
        if let imageFromCache = flagImageCache.object(forKey: viewModel.countries[indexPath.row].flag as NSString) {
            cell.updateImageViewWithImage(imageFromCache)
            return
        }
        
        let imageProvider = CacheFlagImageProvider(viewModel.countries[indexPath.row]) { (image) in
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
        viewModel.getSelectedCountry(viewModel.countries[indexPath.row], .net)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .gray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        callSignals()
    }
}
