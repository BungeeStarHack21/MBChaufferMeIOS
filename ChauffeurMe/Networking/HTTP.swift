//
//  HTTP.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum HTTPError: Error {
    case statusCodeNotInSuccessRange(_ statusCode: Int)
    case emptyResponse
    case emptyData
}

enum HTTP {
    private static let jsonDecoder = JSONDecoder()
    
    typealias DoRequestCompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    
    /// Executes the `URLRequest` in the `URLSession`
    /// and passes the decoded object to the `completionHandler` closure.
    static func doRequest<T: Decodable>(
        urlRequest: URLRequest,
        completionHandler: @escaping DoRequestCompletionHandler<T>
    ) {
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
