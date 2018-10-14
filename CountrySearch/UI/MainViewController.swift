//
//  MainViewController.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/10/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import JGProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: MainViewModelProtocol = MainViewModel()
    private let cellID = "MainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = viewModel.regions[indexPath.row]
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading countries"
        hud.show(in: view, animated: true)
        
        viewModel.getRegionData(viewModel.regions[indexPath.row]).start { (event) in
            hud.dismiss(animated: true)
            switch event {
            default: break
            }
        }
    }
}
