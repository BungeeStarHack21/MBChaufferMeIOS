//
//  HTTP.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum HTTP {
    private static let jsonDecoder = JSONDecoder()
    private static let contentTypeHeaderKey = "Content-Type"
    
    typealias DoRequestCompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    
    /// Executes the `URLRequest` in the `URLSession`
    /// and passes the decoded object to the `completionHandler` closure.
    static func doRequest<T: Decodable>(
        httpRequest: HTTPRequest,
        completionHandler: @escaping DoRequestCompletionHandler<T>
    ) {
        let urlRequest = urlRequest(from: httpRequest)
        
        let task = URLSession.shared.dataTask(
            with: urlRequest
        ) { (data,  response, error) in
            if let error = error {
                completionHandler(.failure(error))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(HTTPError.emptyResponse))
                
                return
            }
            
            if !isSuccess(statusCode: response.statusCode) {
                completionHandler(.failure(
                    HTTPError.statusCodeNotInSuccessRange(
                        response.statusCode
                    )
                ))
                
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(HTTPError.emptyData))
                
                return
            }
            
            let decodeResult = decode(data: data, into: T.self)
            
            completionHandler(decodeResult)
        }
        
        task.resume()
    }
    
    private static func urlRequest(
        from httpRequest: HTTPRequest
    ) -> URLRequest {
        var urlRequest = URLRequest(url: httpRequest.url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        urlRequest.httpBody = httpRequest.body
        
        if httpRequest.body != nil {
            urlRequest.addValue(
                HTTPContentType.applicationJson.rawValue,
                forHTTPHeaderField: contentTypeHeaderKey
            )
        }
        
        return urlRequest
    }
    
    private static func decode<T: Decodable>(data: Data, into: T.Type) -> Result<T, Error> {
        do {
            return .success(try jsonDecoder.decode(T.self, from: data))
        } catch {
            return .failure(error)
        }
    }
    
    private static func isSuccess(statusCode: Int) -> Bool {
        statusCode >= 200 && statusCode <= 299
    }
}
