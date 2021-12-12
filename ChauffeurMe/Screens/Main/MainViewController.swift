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
        LocationWatcher.shared.delegate = self
    }
}

// MARK: - Location Delegate

extension MainViewController: LocationWatcherDelegate {
    func locationUpdated(_ location: Location) {
        API.findNearestRings(
            by: location.latitude,
            and: location.longitude,
            radius: 0.5
        ) { [weak self] result in
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
            self.removeRings()
            self.drawRings()
            self.focusToUserIfLastIsPresent()
        }
    }
    
    private func removeRings() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    private func drawRings() {
        for (ringIndex, ring) in nearestRings.enumerated() {
            for (nodeIndex, node) in ring.nodes.enumerated() {
                let nextNode: NearestRing.Node
                
                if nodeIndex < ring.nodes.count - 1 {
                    nextNode = ring.nodes[nodeIndex + 1]
                } else {
                    nextNode = ring.nodes[0]
                }
                
                let request = MKDirections.Request()
                request.source = .init(
                    placemark: .init(
                        coordinate: .init(
                            latitude: .init(node.latitude),
                            longitude: .init(node.longitude)
                        )
                    )
                )
                request.destination = .init(
                    placemark: .init(
                        coordinate: .init(
                            latitude: .init(nextNode.latitude),
                            longitude: .init(nextNode.longitude)
                        )
                    )
                )
                
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                
                directions.calculate { [weak self] response, error in
                    guard let self = self, let response = response else { return }
                    
                    let first = response.routes.first!
                    
                    first.polyline.title = String(ringIndex)
                    
                    self.mapView.addOverlay(first.polyline)
                }
            }
        }
    }
    
    private func focusToUserIfLastIsPresent() {
        guard let location = LocationWatcher.shared.last else {
            return
        }
        
        self.mapView.setRegion(.init(center: .init(latitude: Double(location.latitude), longitude: Double(location.longitude)), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
}

// MARK: - Map View Delegate

extension MainViewController: MKMapViewDelegate {
    private static let colors: [UIColor] = [
        .red, .green, .blue, .brown, .orange, .magenta
    ]
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let index = Int(overlay.title!!)!
        
        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = Self.colors[index]

        renderer.lineWidth = 5.0

        return renderer
    }

}
