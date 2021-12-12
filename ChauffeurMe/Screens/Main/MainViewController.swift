//
//  MainViewController.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
    }
}

// MARK: - Map View

extension MainViewController {
    private func configureMapView() {
        
    }
}
