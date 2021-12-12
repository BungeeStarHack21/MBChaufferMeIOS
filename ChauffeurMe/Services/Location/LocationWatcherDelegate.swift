//
//  LocationWatcherDelegate.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

protocol LocationWatcherDelegate: AnyObject {
    func locationUpdated(_ location: Location)
}
