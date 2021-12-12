//
//  Threads.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import Foundation

enum Threads {
    static func runOnMainThreadSync<T>(_ task: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try task()
        }
        
        return try DispatchQueue.main.sync {
            try task()
        }
    }
    
    /// Executes given block on the main thread in an async way.
    /// - Parameter task: block to execute.
    static func runOnMainThread(_ task: @escaping () -> Void) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
    
}
