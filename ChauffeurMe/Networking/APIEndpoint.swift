//
//  APIEndpoint.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum APIEndpoint {
    case nearestRings(latitude: Float, longitude: Float, radius: Float)
}

extension APIEndpoint {
    var method: HTTPMethod {
        switch self {
        case .nearestRings:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .nearestRings:
            return "/rings/nearest"
        }
    }
    
    var queryParameters: [String: String] {
        switch self {
        case let .nearestRings(latitude, longitude, radius):
            return [
                "latitude": String(latitude),
                "longitude": String(longitude),
                "radius": String(radius),
            ]
        }
    }
}
