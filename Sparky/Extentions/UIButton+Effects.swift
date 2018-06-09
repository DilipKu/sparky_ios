//
//  UIButton+Effects.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/10/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import Foundation
import UIKit
extension UIButton
{
    func setButtonBorder()
    {
        self.layer.borderWidth=1.0;
        self.layer.borderColor=UIColor.white.cgColor
        self.layer.cornerRadius=5;
        self.clipsToBounds=true
    }
}
