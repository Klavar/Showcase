//
//  MaterialTextField.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 05/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {


    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(colorLiteralRed: Float(SHADOW_COLOR), green: Float(SHADOW_COLOR), blue: Float(SHADOW_COLOR), alpha: 0.5).cgColor
        layer.borderWidth = 1.0
        
    }
    //For Placeholder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    //For editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
