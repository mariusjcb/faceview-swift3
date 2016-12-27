//
//  ViewController.swift
//  FaceView
//
//  Created by Marius Ilie on 23/12/16.
//  Copyright © 2016 University of Bucharest - Marius Ilie. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var mouthCurvature = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var UIFaceView: FaceView! {
        didSet {
            UIFaceView.addGestureRecognizer(UIPinchGestureRecognizer(target: UIFaceView, action: #selector(FaceView.changeScale(recognizer:))))
            
            // swipe up
            
            let upGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness(recognizer:)))
            upGestureRecognizer.direction = .down
            
            UIFaceView.addGestureRecognizer(upGestureRecognizer)
            
            // swipe down
            
            let downGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness(recognizer:)))
            downGestureRecognizer.direction = .up
            
            UIFaceView.addGestureRecognizer(downGestureRecognizer)
            
            // tap gesture
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FaceViewController.toggleEyes(recognizer:)))
            
            UIFaceView.addGestureRecognizer(tapGestureRecognizer)
            
            updateUI()
        }
    }
    
    func increaseHappiness(recognizer: UISwipeGestureRecognizer)
    {
        UIFaceView.mouthCurvature = UIFaceView.mouthCurvature + 0.5
    }
    
    func decreaseHappiness(recognizer: UISwipeGestureRecognizer)
    {
        UIFaceView.mouthCurvature = UIFaceView.mouthCurvature - 0.5
    }
    
    func toggleEyes(recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .ended {
            if UIFaceView.eyesOpened {
                UIFaceView.eyesOpened = false
            } else {
                UIFaceView.eyesOpened = true
            }
        }
    }
    
    func updateUI() {
        if UIFaceView != nil {
            UIFaceView.mouthCurvature = mouthCurvature
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
    }
}

