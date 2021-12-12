//
//  HTTPRequest.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

struct HTTPRequest {
    let method: HTTPMethod
    let url: URL
    let body: Data?
    
    init(method: HTTPMethod, url: URL, body: Data? = nil) {
        self.method = method
        self.url = url
        self.body = body
    }
}
