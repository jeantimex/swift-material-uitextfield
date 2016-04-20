//
//  MaterialUITextField.swift
//  Material UITextField
//
//  Created by Yong Su on 4/18/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

@IBDesignable
class MaterialUITextField: UITextField {
    
    var borderLayer: CAShapeLayer!
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBorder()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawBorder()
    }
    
    //
    // Add border layer as sub layer
    //
    func layoutBorder() {
        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            borderLayer.frame = layer.bounds
            layer.addSublayer(borderLayer)
        }
    }
    
    //
    // Redraw the border
    //
    func drawBorder() {
        if borderLayer != nil {
            let size = layer.frame.size
            let path = UIBezierPath()
            
            path.moveToPoint(CGPointMake(0, size.height))
            path.addLineToPoint(CGPointMake(size.width, size.height))
            path.closePath()
            
            borderLayer.lineWidth = borderWidth
            borderLayer.strokeColor = borderColor.CGColor
            borderLayer.path = path.CGPath
        }
    }
    
}