//
//  Location.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation
import CoreLocation

class LocationWatcher: NSObject {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationManager
    }()
    
    static let shared = LocationWatcher()
    
    weak var delegate: LocationWatcherDelegate? {
        didSet {
            locationManager.requestLocation()
        }
    }
    
    private(set) var last: Location? {
        didSet {
            fireDelegateIfLastIsPresent()
        }
    }
    
    private override init() {
        
    }
    
    func ensurePermissionIsGranted() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func fireDelegateIfLastIsPresent() {
        guard let last = last else {
            return
        }
        
        delegate?.locationUpdated(last)
    }
}

extension LocationWatcher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("Location was not present")
            
            return
        }
        
        last = .init(
            latitude: Float(location.coordinate.latitude),
            longitude: Float(location.coordinate.longitude)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

