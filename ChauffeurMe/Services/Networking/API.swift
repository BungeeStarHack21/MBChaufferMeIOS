//
//  API.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum API {
    private static let jsonEncoder = JSONEncoder()
    private static let baseURL = URL(string: "http://172.20.10.6:8083/rest")
    
    static func findNearestRings(
        by latitude: Float,
        and longitude: Float,
        radius: Float,
        completionHandler:
            @escaping HTTP.DoRequestCompletionHandler<[NearestRing]>
    ) {
        guard let httpRequest = httpRequest(
            for: .nearestRings(
                latitude: latitude,
                longitude: longitude,
                radius: radius
            )
        ) else {
            completionHandler(.failure(APIError.failedToBuildHTTPRequest))
            
            return
        }
        
        HTTP.doRequest(
            httpRequest: httpRequest,
            completionHandler: completionHandler
        )
    }
    
    static func bookRide(
        request: BookRequest,
        completionHandler:
            @escaping HTTP.DoRequestCompletionHandler<BookResponse>
    ) {
        guard let httpRequest = httpRequest(for: .book(request: request), and: try? jsonEncoder.encode(request)) else {
            completionHandler(.failure(APIError.failedToBuildHTTPRequest))
            
            return
        }
        
        HTTP.doRequest(
            httpRequest: httpRequest,
            completionHandler: completionHandler
        )
    }
    
    private static func httpRequest(
        for endpoint: APIEndpoint,
        and body: Data? = nil
    ) -> HTTPRequest? {
        guard let baseURL = baseURL else {
            return nil
        }
        
        guard var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            return nil
        }
        
        urlComponents.queryItems = endpoint
            .queryParameters
            .map { queryParameter in
                .init(name: queryParameter.key, value: queryParameter.value)
            }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return .init(method: endpoint.method, url: url, body: body)
    }
}
