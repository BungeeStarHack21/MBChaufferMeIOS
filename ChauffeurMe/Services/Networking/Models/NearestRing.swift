//
//  NearestRing.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

struct NearestRing: Decodable {
    let id: Int
    let name: String
    let nodes: [Node]
    
    struct Node: Decodable {
        let id: Int
        let order: Int
        let name: String
        let latitude: Float
        let longitude: Float
        let chauffeurTimes: [ChauffeurTime]
        
        struct ChauffeurTime: Decodable {
            let id: Int
            let time: String
        }
    }
}
