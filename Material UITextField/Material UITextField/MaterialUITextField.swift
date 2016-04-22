//
//  MaterialUITextField.swift
//  Material UITextField
//
//  Created by Yong Su on 4/18/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

@IBDesignable class MaterialUITextField: UITextField {
    
    //
    //# MARK: - Variables
    //
    
    // Bottom border layer
    private var borderLayer: CAShapeLayer!
    // Top label layer
    private var labelLayer: CATextLayer!
    // Note icon layer
    private var noteIconLayer: CATextLayer!
    // Note text layer
    private var noteTextLayer: CATextLayer!
    // Note font size
    private var noteFontSize: CGFloat = 12.0
    // Cache secure text initial state
    private var isSecureText: Bool?
    // The button to toggle secure text entry
    private var secureToggler: UIButton!
    
    private enum icon: String {
        case openEye = "\u{f06e}"
        case closedEye = "\u{f070}"
    }
    
    // The color of the bottom border
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The widht of the bottom border
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of the label
    @IBInspectable var labelColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of note text
    @IBInspectable var noteTextColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The note text
    @IBInspectable var noteText: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The color of note icon
    var noteIconColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // The note icon
    var noteIcon: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var secureTextEntry: Bool {
        set {
            super.secureTextEntry = newValue
            // Here we remember the initial secureTextEntry setting
            if isSecureText == nil && newValue {
                isSecureText = true
            }
        }
        get {
            return super.secureTextEntry
        }
    }
    
    //
    //# MARK: - Initialization
    //
    
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initRightView()
        registerNotifications()
    }
    #endif
    
    //
    // Cleanup the notification/event listeners when the view is about to dissapear
    //
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        
        if newWindow == nil {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        } else {
            registerNotifications()
        }
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MaterialUITextField.onTextChanged), name: UITextFieldTextDidChangeNotification, object: self)
    }
    
    func initRightView() {
        if isSecureText != nil {
            // Show the secure text toggler
            let togglerText: String = icon.closedEye.rawValue
            let togglerFont: UIFont = UIFont(name: "FontAwesome", size: 14.0)!
            let togglerTextSize = (togglerText as NSString).sizeWithAttributes([NSFontAttributeName: togglerFont])
            
            secureToggler = UIButton(type: UIButtonType.Custom)
            secureToggler.frame = CGRectMake(0, 0, togglerTextSize.width, togglerTextSize.height)
            secureToggler.setTitle(togglerText, forState: UIControlState.Normal)
            secureToggler.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            secureToggler.titleLabel?.font = togglerFont
            secureToggler.addTarget(self, action: #selector(MaterialUITextField.toggleSecureTextEntry), forControlEvents: .TouchUpInside)
            
            rightView = secureToggler
            rightViewMode = UITextFieldViewMode.Always
        } else {
            // Show the clear button
            self.clearButtonMode = UITextFieldViewMode.WhileEditing
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
        if labelLayer == nil && placeholder != nil {
            let labelSize = ((placeholder! as NSString)).sizeWithAttributes([NSFontAttributeName: font!])
            
            labelLayer = CATextLayer()
            labelLayer.opacity = 0
            labelLayer.string = placeholder
            labelLayer.font = font
            labelLayer.fontSize = (font?.pointSize)!
            labelLayer.foregroundColor = labelColor.CGColor
            labelLayer.wrapped = false
            labelLayer.alignmentMode = kCAAlignmentLeft
            labelLayer.contentsScale = UIScreen.mainScreen().scale
            labelLayer.frame = CGRectMake(0, (layer.bounds.size.height - labelSize.height) / 2.0, labelSize.width, labelSize.height)
            
            layer.addSublayer(labelLayer)
        }
    }
    
    func setupNote() {
        if noteIconLayer == nil {
            noteIconLayer = CATextLayer()
            noteIconLayer.font = "FontAwesome"
            noteIconLayer.fontSize = noteFontSize
            noteIconLayer.alignmentMode = kCAAlignmentLeft
            noteIconLayer.contentsScale = UIScreen.mainScreen().scale
            
            layer.addSublayer(noteIconLayer)
        }
        
        if noteTextLayer == nil {
            noteTextLayer = CATextLayer()
            noteTextLayer.font = font
            noteTextLayer.fontSize = noteFontSize
            noteTextLayer.wrapped = true
            noteTextLayer.alignmentMode = kCAAlignmentLeft
            noteTextLayer.contentsScale = UIScreen.mainScreen().scale
            
            layer.addSublayer(noteTextLayer)
        }
    }
    
    //
    //# MARK: - Renderers
    //
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayer()
    }
    
    func setupLayer() {
        layer.masksToBounds = false
        
        setupBorder()
        setupLabel()
        setupNote()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        drawBorder()
        drawLabel()
        drawNote()
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
    
    //
    // Redraw the note
    //
    func drawNote() {
        var startX:CGFloat = 0.0
        
        if noteIconLayer != nil {
            let noteIconFont: UIFont = UIFont(name: "FontAwesome", size: noteFontSize)!
            let noteIconSize = ((noteIcon ?? "") as NSString).sizeWithAttributes([NSFontAttributeName: noteIconFont])
            
            noteIconLayer.string = noteIcon
            noteIconLayer.foregroundColor = noteIconColor.CGColor
            noteIconLayer.frame = CGRectMake(0, layer.bounds.size.height + 5.0, noteIconSize.width, noteIconSize.height)
            
            if noteIcon != nil {
                startX = noteIconSize.width + 5.0
            }
        }
        
        if noteTextLayer != nil {
            let noteWidth = layer.bounds.size.width - startX
            let noteHeight = (noteText ?? "").heightWithConstrainedWidth(noteWidth, font: UIFont(name: (font?.fontName)!, size: noteFontSize)!)
            
            noteTextLayer.string = noteText
            noteTextLayer.foregroundColor = noteTextColor.CGColor
            noteTextLayer.frame = CGRectMake(startX, layer.bounds.size.height + 2.0, noteWidth, noteHeight)
        }
    }
    
    //
    //# MARK: - Event handlers
    //
    
    func toggleSecureTextEntry() {
        // Resign and restore the first responder
        // solves the font issue
        resignFirstResponder()
        secureTextEntry = !secureTextEntry
        becomeFirstResponder()
        
        secureToggler.setTitle(secureTextEntry ? icon.closedEye.rawValue : icon.openEye.rawValue, forState: UIControlState.Normal)
        
        // A trick to reset the cursor position after toggle secureTextEntry
        let temp = text
        text = nil
        text = temp
    }
    
    //
    // Apply animations when editing text
    //
    func onTextChanged() {
        if placeholder == nil || labelLayer == nil {
            return
        }
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        
        if text?.characters.count == 0 {
            // Move the label back
            opacityAnimation.toValue = 0
            let labelSize = ((placeholder! as NSString)).sizeWithAttributes([NSFontAttributeName: font!])
            positionAnimation.toValue = (layer.bounds.size.height - labelSize.height) / 2.0
        } else {
            // Move up the label
            opacityAnimation.toValue = 1
            let labelSize = ((placeholder! as NSString)).sizeWithAttributes([NSFontAttributeName: font!])
            positionAnimation.toValue = -labelSize.height
        }
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnimation, positionAnimation]
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.duration = 0.2
        
        labelLayer.addAnimation(group, forKey: nil)
    }
    
}