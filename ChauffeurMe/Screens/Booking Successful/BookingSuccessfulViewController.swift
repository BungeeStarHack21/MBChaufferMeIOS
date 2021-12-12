//
//  BookingSuccessfulViewController.swift
//  ChauffeurMe
//
//  Created by Doğu Emre DEMİRÇİVİ on 12.12.2021.
//

import UIKit

class BookingSuccessfulViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func goToHomeTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateInitialViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
    }
}
