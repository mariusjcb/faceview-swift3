//
//  BlinkingFaceViewController.swift
//  FaceView
//
//  Created by Marius Ilie on 01/01/17.
//  Copyright © 2017 University of Bucharest - Marius Ilie. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {
    var blinking = false {
        didSet {
            startBlink()
        }
    }
    
    private struct BlinkRate {
        static let CloseDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    @objc private func startBlink() {
        if blinking {
            UIFaceView?.eyesOpened = false
            
            Timer.scheduledTimer(
                timeInterval: BlinkRate.CloseDuration,
                target: self,
                selector: #selector(BlinkingFaceViewController.endBlink),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc private func endBlink() {
        UIFaceView.eyesOpened = true
        
        Timer.scheduledTimer(
            timeInterval: BlinkRate.OpenDuration,
            target: self,
            selector: #selector(BlinkingFaceViewController.startBlink),
            userInfo: nil,
            repeats: false
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        blinking = false
    }
}
