//
//  APIEndpoint.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum APIEndpoint {
    case nearestRings(latitude: Float, longitude: Float, radius: Float)
    case book(request: BookRequest)
}

extension APIEndpoint {
    var method: HTTPMethod {
        switch self {
        case .nearestRings:
            return .get
            
        case .book:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .nearestRings:
            return "/rings/nearest"
            
        case .book:
            return "/rides"
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
            
        case .book:
            return [:]
        }
    }
}
