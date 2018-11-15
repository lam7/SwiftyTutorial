//
//  SwiftyTutorialView.swift
//  SwiftyTutorial
//
//  Created by main on 2018/11/08.
//  Copyright © 2018 lam7. All rights reserved.
//

import Foundation
import UIKit

public protocol TutorialDescriptional{
    
}
private extension Array{
    mutating func removeSafety(at: Int)-> Element?{
        if 0 <= at && at < count{
            return self.remove(at: at)
        }
        return nil
    }
}
class SwiftyTutorialView: UIView{
    open weak var maskLayer: CAShapeLayer!
    open weak var markView: UIView!
    open var markSpace: CGFloat = 0
    open var spotType: SpotType = .circle
    open var targetsSpotFrame: [CGRect] = []
    open var targetsHitFrame: [CGRect] = []
    open var targetsMarkDirection: [Direction] = []
    open var animationDuration: TimeInterval = 0.5
    open var animationWidth: CGFloat = 20
    
    private var hitFrame: CGRect = .zero
    
    public enum Direction{
        case left, right, up, down
    }
    
    public enum SpotType{
        case circle, square, other(UIBezierPath)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        let markView = ArrowView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        addSubview(markView)
        self.markView = markView
    }
    
//    public init(frame: CGRect, markView: UIView){
//        super.init(frame: frame)
//        setUp()
//        addSubview(markView)
//        self.markView = markView
//    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.6).cgColor
        layer.addSublayer(maskLayer)
        self.maskLayer = maskLayer
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard self.bounds.contains(point) else{
            return false
        }
        
        return !hitFrame.contains(point)
    }
    
    private func fillRectLayer(){
        let path = UIBezierPath(rect: bounds)
        
        guard let spotFrame = targetsSpotFrame.first else{
            maskLayer.path = path.cgPath
            return
        }
        
        var cutPath: UIBezierPath
        switch spotType {
        case .circle:
            cutPath = UIBezierPath(ovalIn: spotFrame)
        case .square:
            cutPath = UIBezierPath(rect: spotFrame)
        case .other(let path):
            cutPath = path
        }
        
        path.append(cutPath)
        
        maskLayer.path = path.cgPath
    }
    
    private func moveMarkView(_ target: CGRect){
        let w = markView.frame.width
        let h = markView.frame.height
        let direction = targetsMarkDirection.first ?? .down
        switch direction {
        case .up:
            var x = target.midX - w / 2
            x = max(0, x)
            x = min(UIScreen.main.bounds.width - w, x)
            markView.frame = CGRect(x: x, y: target.minY - markSpace - h, width: w, height: h)
        case .down:
            var x = target.midX - w / 2
            x = max(0, x)
            x = min(UIScreen.main.bounds.width - w, x)
            markView.frame = CGRect(x: x, y: target.maxY + markSpace, width: w, height: h)
        case .left:
            var y = target.midY - h / 2
            y = max(0, y)
            y = min(UIScreen.main.bounds.height - h, y)
            markView.frame = CGRect(x: target.minX - markSpace - w, y: y, width: w, height: h)
        case .right:
            var y = target.midY - h / 2
            y = max(0, y)
            y = min(UIScreen.main.bounds.height - h, y)
            markView.frame = CGRect(x: target.maxX + markSpace, y: y, width: w, height: h)
        }
    }
    
    
    open func append(_ target: UIView, direction: Direction = .down){
        targetsSpotFrame.append(target.frame)
        targetsHitFrame.append(target.frame)
        targetsMarkDirection.append(direction)
    }
    
    open func append(_ target: UIView, parent: UIViewController, direction: Direction = .down){
        let frame = parent.view.convert(target.frame, from: target.superview)
        targetsSpotFrame.append(frame)
        targetsHitFrame.append(frame)
        targetsMarkDirection.append(direction)
    }
    
    open func append(_ spot: CGRect, hit: CGRect, direction: Direction = .down){
        targetsSpotFrame.append(spot)
        targetsHitFrame.append(hit)
        targetsMarkDirection.append(direction)
    }
    
    private func animationArrow(_ duration: TimeInterval, d: CGFloat){
        let direction = self.targetsMarkDirection.first ?? .down
        UIView.animate(withDuration: duration, delay: 0, options: .repeat, animations: {
            switch direction{
            case .up:
                self.markView.center.y += d
            case .down:
                self.markView.center.y -= d
            case .left:
                self.markView.center.x += d
            case .right:
                self.markView.center.x -= d
            }
            
        }, completion: nil)
    }
    
    open func next(){
        let hit = targetsHitFrame.removeSafety(at: 0) ?? bounds
        let spot = targetsSpotFrame.removeSafety(at: 0) ?? bounds
        let direction = targetsMarkDirection.removeSafety(at: 0) ?? .down
        self.hitFrame = hit
        fillRectLayer()
        moveMarkView(spot)
        animationArrow(animationDuration, d: animationWidth)
    }
}

