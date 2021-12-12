//
//  LocationDelegate.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

protocol LocationDelegate: AnyObject {
    func locationUpdated(latitude: Float, longitude: Float)
}
