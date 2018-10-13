//
//  CountriesViewController.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/11/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    let viewModel: CountriesViewModelProtocol = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        flagImageCache.removeAllObjects()
    }
    
    private func setup() {
        tableView.register(CountriesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountriesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.countryData = viewModel.countries[indexPath.row]
        return cell
    }
}

extension CountriesViewController: UITableViewDelegate {
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
        viewModel.getSelectedCountry(viewModel.countries[indexPath.row])
    }
}
