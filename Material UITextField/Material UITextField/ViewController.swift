//
//  ViewController.swift
//  Material UITextField
//
//  Created by Yong Su on 4/18/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.CaseInsensitive])
        return regex.firstMatchInString(self, options:[], range: NSMakeRange(0, utf16.count)) != nil
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailInput: MaterialUITextField!
    @IBOutlet var passwordInput: MaterialUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.delegate = self
        passwordInput.delegate = self
    }

    //
    //# MARK: - UITextFieldDelegate
    //
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == emailInput {
            if (emailInput.text!.isEmpty) {
                emailInput.noteIcon = nil
                emailInput.noteTextColor = UIColor.darkGrayColor()
                emailInput.noteText = "Example: jean.timex@gmail.com"
            }
            else if emailInput.text!.isEmail() {
                emailInput.noteIconColor = UIColorFromRGB(0x26A65B)
                emailInput.noteIcon = "\u{f058}"
                emailInput.noteTextColor = UIColorFromRGB(0x26A65B)
                emailInput.noteText = "This email address is valid"
            } else {
                emailInput.noteIconColor = UIColorFromRGB(0xC0392B)
                emailInput.noteIcon = "\u{f071}"
                emailInput.noteTextColor = UIColorFromRGB(0xC0392B)
                emailInput.noteText = "Invalid email address"
            }
        } else if textField == passwordInput {
            if (passwordInput.text!.isEmpty) {
                passwordInput.noteIcon = nil
                passwordInput.noteTextColor = UIColorFromRGB(0xE87E04)
                passwordInput.noteText = "At least 8 characters"
            } else if passwordInput.text!.characters.count >= 8 {
                passwordInput.noteIconColor = UIColorFromRGB(0x26A65B)
                passwordInput.noteIcon = "\u{f058}"
                passwordInput.noteTextColor = UIColorFromRGB(0x26A65B)
                passwordInput.noteText = "This password is valid"
            } else {
                passwordInput.noteIconColor = UIColorFromRGB(0xC0392B)
                passwordInput.noteIcon = "\u{f06a}"
                passwordInput.noteTextColor = UIColorFromRGB(0xC0392B)
                passwordInput.noteText = "This password is valid"
            }
        }
    }
    
    //
    // Help function: UInt to UIColor
    // Usage: UIColorFromRGB(0x26A65B)
    //
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

