//
//  BookRequest.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

struct BookRequest: Encodable {
    let customerUserId: Int
    let startChauffeurRingNodeTimeId: Int
    let endChauffeurRingNodeTimeId: Int
    let seatCount: Int
}
