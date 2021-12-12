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
    
    private var nearestRings: [NearestRing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToLocation()
        configureMapView()
    }
}

// MARK: - Nearest Rings

extension MainViewController {
    private func fetchNearestRings() {
        
    }
}

// MARK: - Location

extension MainViewController {
    private func subscribeToLocation() {
        Location.shared.delegate = self
    }
}

// MARK: - Location Delegate

extension MainViewController: LocationDelegate {
    func locationUpdated(latitude: Float, longitude: Float) {
        API.findNearestRings(by: latitude, and: longitude, radius: 0.5) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(nearestRings):
                self.nearestRings = nearestRings
                
                self.updateMapView()
                
            case let .failure(error):
                print(error)
            }
        }
    }
}

// MARK: - Map View

extension MainViewController {
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func updateMapView() {
        Threads.runOnMainThread {
            print(self.nearestRings)
            
            self.emre()
        }
    }
    
    private func emre() {
        let nodes = nearestRings.last?.nodes ?? []
        
        for (index, node) in nodes.enumerated() {
            let nextNode: NearestRing.Node
            
            if index < nodes.count - 1 {
                nextNode = nodes[index + 1]
            } else {
                // TODO: Do not force unwrap
                nextNode = nodes.first!
            }
            
            let request = MKDirections.Request()
            request.source = .init(placemark: .init(coordinate: .init(latitude: .init(node.latitude), longitude: .init(node.longitude))))
            request.destination = .init(placemark: .init(coordinate: .init(latitude: .init(nextNode.latitude), longitude: .init(nextNode.longitude))))
            
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate { [weak self] response, error in
                guard let response = response else { return }
                
                let first = response.routes.first!
                
                self?.mapView.addOverlay(first.polyline)
                self?.mapView.setVisibleMapRect(first.polyline.boundingMapRect, animated: true)
            }
        }
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotation1.coordinate, addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation2.coordinate, addressDictionary: nil))
//        request.requestsAlternateRoutes = true
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//
//        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//
//            if (unwrappedResponse.routes.count > 0) {
//                self.mapView.addOverlay(unwrappedResponse.routes[0].polyline)
//                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
//            }
//        }
    }
}

// MARK: - Map View Delegate

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

        renderer.lineWidth = 5.0

        return renderer
    }

}
