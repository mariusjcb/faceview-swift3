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
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FaceViewController.headSake(recognizer:)))
            
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
    
    private struct Animation {
        static let shakeAngle = CGFloat(M_PI/6)
        static let shakeDuration = 0.5
    }
    
    func headSake(recognizer: UITapGestureRecognizer)
    {
        UIView.animate(
            withDuration: Animation.shakeDuration,
            animations: { [weak weakSelf = self] in
                weakSelf?.UIFaceView.transform = (weakSelf?.UIFaceView.transform.rotated(by: Animation.shakeAngle))!
            }, completion: { (finished) in
                if finished {
                    UIView.animate(
                        withDuration: Animation.shakeDuration,
                        animations: { [weak weakSelf = self] in
                            weakSelf?.UIFaceView.transform = (weakSelf?.UIFaceView.transform.rotated(by: -Animation.shakeAngle*2))!
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(
                                    withDuration: Animation.shakeDuration,
                                    animations: { [weak weakSelf = self] in
                                        weakSelf?.UIFaceView.transform = (weakSelf?.UIFaceView.transform.rotated(by: Animation.shakeAngle))!
                                    }
                                )
                            }
                        }
                    )
                }
            }
        )
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

