//
//  ArrowView.swift
//  SwiftyTutorial
//
//  Created by main on 2018/11/09.
//  Copyright © 2018 lam7. All rights reserved.
//

import Foundation
import UIKit

class ArrowView: UIView{
    override class var layerClass : AnyClass{
        return CAShapeLayer.self
    }
    
    var direction: Direction = .down{
        didSet{
            setNeedsLayout()
        }
    }
    
    enum Direction: CGFloat{
        case right = 0.0, up = 90.0, left = 180.0, down = 270.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        (layer as! CAShapeLayer).path = arrowPath(angle: direction.rawValue, headRate: 0.8, tailRate: 0.6, frame: rect)
    }
    
    func arrowPath(angle: CGFloat, headRate: CGFloat, tailRate: CGFloat, frame: CGRect)-> CGPath{
        let path = UIBezierPath()
        let headWidth = headRate * frame.width
        let tailY = frame.height * tailRate
        let headMinX = frame.midX - headWidth / 2
        let headMaxX = frame.midX + headWidth / 2
        path.move(to: CGPoint(x: headMinX, y: 0))
        path.addLine(to: CGPoint(x: headMinX, y: tailY))
        path.addLine(to: CGPoint(x: 0, y: tailY))
        path.addLine(to: CGPoint(x: frame.midX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.maxX, y: tailY))
        path.addLine(to: CGPoint(x: headMaxX, y: tailY))
        path.addLine(to: CGPoint(x: headMaxX, y: 0))
        path.addLine(to: CGPoint(x: headMinX, y: 0))
        path.close()
        
        path.apply(CGAffineTransform(rotationAngle: ((90.0 + angle) * CGFloat.pi / 180.0)))
        return path.cgPath
    }
}
