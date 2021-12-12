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
    
    private var nearestRings: [NearestRing]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
    }
}

// MARK: - Nearest Rings

extension MainViewController {
    private func fetchNearestRings() {
        API.findNearestRings(by: <#T##Float#>, and: <#T##Float#>, radius: <#T##Float#>, completionHandler: <#T##HTTP.DoRequestCompletionHandler<[NearestRing]>##HTTP.DoRequestCompletionHandler<[NearestRing]>##(_ result: Result<[NearestRing], Error>) -> Void#>)
    }
}

// MARK: - Map View

extension MainViewController {
    private func configureMapView() {
        
    }
}
