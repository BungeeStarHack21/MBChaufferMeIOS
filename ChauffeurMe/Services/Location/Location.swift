//
//  Location.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation
import CoreLocation

class Location: NSObject {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationManager
    }()
    
    static let shared = Location()
    
    weak var delegate: LocationDelegate? {
        didSet {
            locationManager.requestLocation()
        }
    }
    
    private override init() {
        
    }
    
    func ensurePermissionIsGranted() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func fireDelegate(latitude: Float, longitude: Float) {
        delegate?.locationUpdated(latitude: latitude, longitude: longitude)
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("Location was not present")
            
            return
        }
        
        fireDelegate(
            latitude: Float(location.coordinate.latitude),
            longitude: Float(location.coordinate.longitude)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

