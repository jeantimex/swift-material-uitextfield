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
    var labelLayer: CATextLayer!
    var placeholderText: String?
    
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
    
    @IBInspectable
    var labelColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var placeholder: String? {
        didSet {
            placeholderText = oldValue
        }
    }
    
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerNotifications()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerNotifications()
    }
    #endif
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MaterialUITextField.onTextEndEditing), name: UITextFieldTextDidEndEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MaterialUITextField.onTextBeginEditing), name: UITextFieldTextDidBeginEditingNotification, object: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawBorder()
        drawLabel()
    }
    
    func setupLayer() {
        layer.masksToBounds = false
        
        setupBorder()
        setupLabel()
    }
    
    func onTextBeginEditing() {
        placeholder = nil
        
        if labelLayer != nil {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.toValue = 1
            
            let positionAnimation = CABasicAnimation(keyPath: "position.y")
            positionAnimation.toValue = -labelLayer.bounds.size.height / 2.0 + 5
            
            let group = CAAnimationGroup()
            group.animations = [opacityAnimation, positionAnimation]
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            group.removedOnCompletion = false
            group.fillMode = kCAFillModeForwards
            group.duration = 0.2
            
            labelLayer.addAnimation(group, forKey: nil)
        }
    }
    
    func onTextEndEditing() {
        placeholder = placeholderText
        
        if text?.characters.count == 0 {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.toValue = 0
            
            let positionAnimation = CABasicAnimation(keyPath: "position.y")
            positionAnimation.toValue = 0
            
            let group = CAAnimationGroup()
            group.animations = [opacityAnimation, positionAnimation]
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            group.removedOnCompletion = false
            group.fillMode = kCAFillModeForwards
            group.duration = 0.2
            
            labelLayer.addAnimation(group, forKey: nil)
        }
    }
    
    //
    // Add border layer as sub layer
    //
    func setupBorder() {
        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            borderLayer.frame = layer.bounds
            layer.addSublayer(borderLayer)
        }
    }
    
    func setupLabel() {
        if labelLayer == nil {
            labelLayer = CATextLayer()
            labelLayer.opacity = 0
            labelLayer.frame = layer.bounds
            labelLayer.string = placeholder
            labelLayer.font = font
            labelLayer.fontSize = (font?.pointSize)!
            labelLayer.foregroundColor = labelColor.CGColor
            labelLayer.wrapped = false
            labelLayer.alignmentMode = kCAAlignmentLeft
            labelLayer.contentsScale = UIScreen.mainScreen().scale
            layer.addSublayer(labelLayer)
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
    
    //
    // Redraw the label
    //
    func drawLabel() {
        if labelLayer != nil {
            labelLayer.foregroundColor = labelColor.CGColor
        }
    }
    
}