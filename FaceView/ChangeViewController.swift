//
//  ChangeViewController.swift
//  FaceView
//
//  Created by Marius Ilie on 27/12/16.
//  Copyright © 2016 University of Bucharest - Marius Ilie. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {
    private let faceConfigurations: Dictionary<String, Double> = [
        "sad" : -1,
        "happy" : 1,
        "neutral" : 0
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        let buttonSender = sender as? UIButton
        
        if let navigationvc = destinationvc as? UINavigationController {
            destinationvc = navigationvc.visibleViewController ?? destinationvc
        }
        
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let mouthCurvature = faceConfigurations[identifier] {
                    facevc.navigationItem.title = buttonSender?.currentTitle
                    facevc.mouthCurvature = mouthCurvature
                }
            }
        }
    }
}
