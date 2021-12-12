//
//  HTTPError.swift
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
