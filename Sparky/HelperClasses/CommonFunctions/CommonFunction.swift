//
//  CommonFunction.swift
//  JustCase
//
//  Created by VISHAL SETH on 10/8/17.
//  Copyright © 2017 Infoicon. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox





class CommonFunction: NSObject
{
   
    static let GetFunctions = CommonFunction()
    
    override private init()
    {
        
    }
    
    
    
    class func setCornorRadius(view:UIView,Radius:CGFloat)
    {
        view.layer.cornerRadius=Radius
        view.clipsToBounds=true
    }
    
    class func isInternetAvailable()->Bool
    {
        let reach = Reachability()!
        if(!reach.isReachable)
        {
            self.showStatusBarNotification(title: "No Internet Connection",color: .red)
        }
        
        return reach.isReachable
    }
    
    
    
    
    
    
    
    class func startLoaderWithoutTitle()
    {
        ACProgressHUD.shared.hideHUD()
    }
    
    class func startLoader(title:String)
    {
        ACProgressHUD.shared.indicatorColor = self.setColorWithHex(hex: "#032B55")
        ACProgressHUD.shared.showHUD(withStatus: "Please wait...")
        ACProgressHUD.shared.enableBackground = true
    }
    
    class func stopLoader()
    {
        ACProgressHUD.shared.hideHUD()
    }
    
    /*
     * Set color with hex
     */
    class func setColorWithHex(hex:String)->UIColor
    {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func showStatusBarNotification(title:String,color:UIColor){
        
        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
            .message(message: title)
            .messageColor(color: .white)
            .bgColor(color: color)
            .completion { print("completion closure will called") }
            .show()
    }
    
    /*
     * Show Alert view
     */
    class func showAlert(message:String)
    {
        let alert = UIAlertView(title: "Sparky", message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    class func getUserIdFromUserDefault()->String
    {
        let dic=UserDefaults.standard.object(forKey:"userData") as! NSDictionary
        
        return dic[USER_DEFAULT_CONSTANT.kUser_id] as! String
    }
    
//    class func ShowError(message:String)
//    {
//        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Just Case", description: message, type:.error)
//    }
//    class func ShowWarning(message:String)
//    {
//        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Just Case", description: message, type:.info)
//    }
//    class func ShowSuccess(message:String)
//    {
//        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Just Case", description: message, type:.success)
//    }
    
    
    class func addShadow(view:UIView)
    {
        view.layer.masksToBounds = false;
        view.layer.shadowColor=UIColor.darkGray.cgColor
        view.layer.shadowOffset=CGSize.init(width: -2, height: -2)
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
    }
    class func setShadowtable(view:UITableView)
    {
        view.layer.masksToBounds = false;
        view.layer.shadowColor=UIColor.darkGray.cgColor
        view.layer.shadowOffset=CGSize.init(width: -2, height: -2)
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
    }
   
   class func SetBoundryButton(btn:UIButton)
    {
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 1.0
    }
    class func SetBoundryLabel(lbl:UILabel)
    {
        lbl.layer.borderColor = UIColor.darkGray.cgColor
        lbl.layer.borderWidth = 1.0
    }
    
    func imageArrayToNSData(array: [UIImage],boundary:String) -> NSData
    {
        let body = NSMutableData()
        var i = 0;
        for image in array
        {
            let filename = "image\(i).jpg"
            let data = UIImageJPEGRepresentation(image,0.8);
            let mimetype = "image/jpeg"
            let key = "images[]"
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            i += 1
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
}
