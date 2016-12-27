//
//  FaceView.swift
//  FaceView
//
//  Created by Marius Ilie on 23/12/16.
//  Copyright © 2016 University of Bucharest - Marius Ilie. All rights reserved.
//

import UIKit

@IBDesignable class FaceView: UIView {
    @IBInspectable private var scale: CGFloat = 0.80 { didSet { setNeedsDisplay() } }
    @IBInspectable public var eyesOpened: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable public var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable public var lineColor: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable public var mouthCurvature: Double = 1.0 {
        didSet {
            if mouthCurvature < -1 || mouthCurvature > 1 {
                mouthCurvature = oldValue;
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    private var blinkTimer: Timer? = nil
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        print(recognizer.state)
        switch recognizer.state {
        case .ended, .changed:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY) // or convert() -> old: convertPoint()
    }
    
    private struct Ratios {
        static let EyeOffset: CGFloat = 3
        static let EyeRadius: CGFloat = 10
        static let MouthWidth: CGFloat = 1
        static let MouthHeight: CGFloat = 3
        static let MouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, widthRadius radius: CGFloat) -> UIBezierPath {
        let bezierPath = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0*M_PI),
            clockwise: false
        )
        bezierPath.lineWidth = lineWidth
        
        return bezierPath
    }
    
    private func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = faceRadius / Ratios.EyeOffset
        var eyeCenter = faceCenter
        
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Ratios.EyeRadius
        let eyeCenter = getEyeCenter(eye)
        
        if eyesOpened {
            return pathForCircleCenteredAtPoint(eyeCenter, widthRadius: eyeRadius)
        } else {
            let bezierPath = UIBezierPath()
            
            bezierPath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            bezierPath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            bezierPath.lineWidth = lineWidth
            
            return bezierPath
        }
    }
    
    private func blinkEyes() {
        if eyesOpened {
            eyesOpened = false
        } else {
            eyesOpened = true
        }
    }
    
    public func blinkEyesCaller() {
        setBlinkTimer()
        blinkEyes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.blinkEyes()
        })
    }
    
    private func setBlinkTimer() {
        blinkTimer?.invalidate()
        blinkTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Int(arc4random_uniform(4) + 2)), target: self, selector: #selector(blinkEyesCaller), userInfo: nil, repeats: true)
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = faceRadius / Ratios.MouthWidth
        let mouthHeight = faceRadius / Ratios.MouthHeight
        let mouthOffset = faceRadius / Ratios.MouthOffset
        
        let mouthRect = CGRect(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: start)
        bezierPath.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        bezierPath.lineWidth = lineWidth;
        
        return bezierPath
    }
    
    public func clearContext() {
        UIBezierPath().stroke()
        self.setNeedsDisplay()
    }
    
    public func drawEntireSmileyFace() {
        lineColor.set() // old version: UIColor.blueColor().set()
        
        pathForCircleCenteredAtPoint(faceCenter, widthRadius: faceRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        
        pathForMouth().stroke()
        
        self.setNeedsDisplay()
        
        if !(blinkTimer != nil) {
            setBlinkTimer()
        }
    }
    
    override func draw(_ rect: CGRect) { // old drawRect
        drawEntireSmileyFace()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setDragGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setDragGesture()
    }
}

extension UIView {
    func setDragGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(UIView.dragUIView(recognizer: )))
        self.addGestureRecognizer(panGesture)
    }
    
    func dragUIView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended, .changed:
            let translation = recognizer.translation(in: superview)
            let oldCenter = self.center
            
            self.center = CGPoint(x: oldCenter.x + translation.x, y: oldCenter.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: superview)
        default:
            break
        }
    }
}
