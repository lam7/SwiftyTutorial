//
//  SwiftyTutorialView.swift
//  SwiftyTutorial
//
//  Created by main on 2018/11/08.
//  Copyright © 2018 lam7. All rights reserved.
//

import Foundation
import UIKit

class SwiftyTutorialView: UIView{
    open weak var maskLayer: CAShapeLayer!{
        didSet{
            maskLayer.fillRule = .evenOdd
            maskLayer.fillColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.6).cgColor
        }
    }
    
    open weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.numberOfLines = 0
            descriptionLabel.backgroundColor = .clear
            descriptionLabel.textColor = .white
        }
    }
    
    open var descriptionDirection: Direction = .down
    open var descriptionSpace: CGFloat = 0
    open var spotType: SpotType = .circle
    
    open var descriptions: [String] = []
    open var targetsSpotFrame: [CGRect] = []
    open var targetsHitFrame: [CGRect] = []
    
    public enum Direction{
        case left, right, up, down
    }
    public enum SpotType{
        case circle, square
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        let maskLayer = CAShapeLayer()
        layer.addSublayer(maskLayer)
        self.maskLayer = maskLayer
        
        let descriptionLabel = UILabel()
        addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard self.bounds.contains(point) else{
            return false
        }
        guard let hitFrame = self.targetsHitFrame.first else{
            return true
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
        }
        
        path.append(cutPath)
        
        maskLayer.path = path.cgPath
    }
    
    private func appearLabel(){
        guard let text = self.descriptions.first,
            let target = self.targetsSpotFrame.first else{
                return
        }
        
        descriptionLabel.text = text
        descriptionLabel.sizeToFit()
        
        let w = descriptionLabel.frame.width
        let h = descriptionLabel.frame.height
        switch descriptionDirection {
        case .up:
            var x = target.midX - w / 2
            x = max(0, x)
            x = min(UIScreen.main.bounds.width - w, x)
            descriptionLabel.frame = CGRect(x: x, y: target.minY - descriptionSpace - h, width: w, height: h)
        case .down:
            var x = target.midX - w / 2
            x = max(0, x)
            x = min(UIScreen.main.bounds.width - w, x)
            descriptionLabel.frame = CGRect(x: x, y: target.maxY + descriptionSpace, width: w, height: h)
        case .left:
            var y = target.midY - h / 2
            y = max(0, y)
            y = min(UIScreen.main.bounds.height - h, y)
            descriptionLabel.frame = CGRect(x: target.minX - descriptionSpace - w, y: y, width: w, height: h)
        case .right:
            var y = target.midY - h / 2
            y = max(0, y)
            y = min(UIScreen.main.bounds.height - h, y)
            descriptionLabel.frame = CGRect(x: target.maxX + descriptionSpace, y: y, width: w, height: h)
        }
    }
    
    
    open func append(_ target: UIView, description: String){
        targetsSpotFrame.append(target.frame)
        targetsHitFrame.append(target.frame)
        descriptions.append(description)
    }
    
    open func append(_ target: UIView, parent: UIViewController, description: String){
        let frame = parent.view.convert(target.frame, from: target.superview)
        print(frame)
        targetsSpotFrame.append(frame)
        targetsHitFrame.append(frame)
        descriptions.append(description)
    }
    
    open func append(_ spot: CGRect, hit: CGRect, description: String){
        targetsSpotFrame.append(spot)
        targetsHitFrame.append(hit)
        descriptions.append(description)
    }
    
    open func start(){
        fillRectLayer()
        appearLabel()
    }
    
    open func next(){
        guard !targetsSpotFrame.isEmpty && !targetsHitFrame.isEmpty && !descriptions.isEmpty else{
            isHidden = true
            return
        }
        targetsSpotFrame.remove(at: 0)
        targetsHitFrame.remove(at: 0)
        descriptions.remove(at: 0)
        fillRectLayer()
        appearLabel()
    }
}

