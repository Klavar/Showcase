//
//  MaterialButton.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 05/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit
import  FBSDKLoginKit
class MaterialButton: UIButton {

    override func awakeFromNib() {
        
       
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(colorLiteralRed: Float(SHADOW_COLOR), green: Float(SHADOW_COLOR), blue: Float(SHADOW_COLOR), alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
