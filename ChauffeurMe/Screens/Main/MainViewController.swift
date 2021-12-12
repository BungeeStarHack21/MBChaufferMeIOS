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
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var seatCountLabel: UILabel!
    
    private var nearestRings: [NearestRing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCenterView()
        subscribeToLocation()
        configureMapView()
        LocationWatcher.shared.fetch()
    }
}

// MARK: - Navigation Item

extension MainViewController {
    private func setCenterView() {
        let image = UIImage(named: "Logo")
        
        let imageView = UIImageView(image: image)
        imageView.frame = .init(x: 0, y: 0, width: 0, height: 0)
        
        navigationItem.titleView = imageView
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
            radius: 10
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
        .init(red: 202 / 255, green: 220 / 255, blue: 245 / 255, alpha: 1),
        .init(red: 160 / 255, green: 70 / 255, blue: 160 / 255, alpha: 1),
        .init(red: 164 / 255, green: 117 / 255, blue: 86 / 255, alpha: 1)
    ]
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let index = Int(overlay.title!!)!
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = Self.colors[index]
        renderer.lineWidth = 5.0

        return renderer
    }
}

// MARK: - First Screen

extension MainViewController {
    @IBAction private func ringDetailsTapped(_ sender: Any) {
        scrollView.setContentOffset(.init(x: scrollView.bounds.width, y: 0), animated: true)
    }
}

// MARK: - Stepper

extension MainViewController {
    private static let people = "people"
    private static let person = "person"
    
    @IBAction private func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        
        let peopleOrPerson = Self.peopleOrPerson(for: value)
        
        seatCountLabel.text = "\(value) \(peopleOrPerson)"
    }
        
    private static func peopleOrPerson(for value: Int) -> String {
        value == 1 ? people : person
    }
}

// MARK: - Book

extension MainViewController {
    @IBAction private func bookTheRideTapped(_ sender: UIButton) {
        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            API.bookRide(request: .init(customerUserId: 2, startChauffeurRingNodeTimeId: 6, endChauffeurRingNodeTimeId: 10, seatCount: 1)) { result in
                Threads.runOnMainThread {
                    self.navigationController?.navigationBar.isHidden = true
                    self.performSegue(withIdentifier: "successSegue", sender: self)
                }
            }
        }
    }
}
