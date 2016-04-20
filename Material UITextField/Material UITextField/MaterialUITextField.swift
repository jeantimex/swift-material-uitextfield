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
    
    var borderLayer: CALayer!
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsUpdate()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsUpdate()
        }
    }
    
    func setNeedsUpdate() {
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorderLayer()
    }
    
    func setBorderLayer() {
        if borderLayer == nil {
            self.borderStyle = UITextBorderStyle.None;
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = borderColor.CGColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
            
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.borderStyle = UITextBorderStyle.None;
    }
    
    
}