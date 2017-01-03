//
//  EyeView.swift
//  FaceView
//
//  Created by Marius Ilie on 03/01/17.
//  Copyright © 2017 University of Bucharest - Marius Ilie. All rights reserved.
//

import UIKit

@IBDesignable class EyeView:UIView {
    @IBInspectable var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable var _eyeOpen: Bool = true { didSet { setNeedsDisplay() } }
    
    var eyeOpen: Bool {
        get {
            return _eyeOpen
        }
        
        set {
            UIView.transition(
                with: self,
                duration: 0.2,
                options: [.transitionFlipFromTop, .curveLinear],
                animations: { [weak weakSelf = self] in
                    weakSelf?._eyeOpen = newValue
                },
                completion: nil
            )
        }
    }
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath!
        
        if eyeOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY/2))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY/2))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}
