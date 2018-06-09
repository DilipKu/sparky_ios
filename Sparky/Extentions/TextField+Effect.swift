//
//  TextField+Effect.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/10/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import Foundation
import UIKit
extension UITextField
{
    func setBorder(placeHolder:String,padding:CGFloat)
    {
        self.layer.borderColor=UIColor.white.cgColor
        self.layer.borderWidth=1.5
        self.layer.cornerRadius=5
        self.clipsToBounds=true
        self.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.tintColor=UIColor.white
        self.font=UIFont.systemFont(ofSize: 18)
        self.textColor=UIColor.white
    }
    
    func setBlackBorder(placeHolder:String,padding:CGFloat)
    {
        self.layer.borderColor=UIColor.darkGray.cgColor
        self.layer.borderWidth=1.5
        self.layer.cornerRadius=5
        self.clipsToBounds=true
        self.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.tintColor=UIColor.black
        self.font=UIFont.systemFont(ofSize: 18)
        self.textColor=UIColor.black
    }
}
