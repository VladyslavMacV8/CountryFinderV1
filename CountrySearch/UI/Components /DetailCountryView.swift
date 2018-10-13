//
//  DetailCountryView.swift
//  CountrySearch
//
//  Created by Vladyslav Kudelia on 10/13/18.
//  Copyright © 2018 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import MapKit

class DetailCountryView: UIView {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    func configData(_ data: CountryEntity) {
        setupImage(data.flag)
        centerMapOnLocation(data.coordinates)
        
        let strings = data.currencies.map { String($0.name) }
        currencyLabel.text = strings.joined(separator: ", ")
        
        let languages = data.languages.map { String($0.name) }
        languageLabel.text = languages.joined(separator: ", ")
    }
    
    private func setupImage(_ value: String) {
        if let imageFromCache = flagImageCache.object(forKey: value as NSString) {
            flagImageView.image = imageFromCache
            return
        }
        
        let operation = CacheFlagImageOperation(value) { [weak self] (image) in
            self?.flagImageView.image = image
        }
        OperationQueue().addOperation(operation)
    }
    
    private func centerMapOnLocation(_ coordinates: [Double]) {
        guard !coordinates.isEmpty else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
}
