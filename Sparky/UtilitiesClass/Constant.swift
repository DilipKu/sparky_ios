//
//  Constant.swift
//  JustCase
//
//  Created by VISHAL-SETH on 11/4/17.
//  Copyright © 2017 Infoicon. All rights reserved.
//

import Foundation
import UIKit



let KDefaultBannerPlaceholder = UIImage.init(named: "banner_placeholder.png")
let kDefaultBrandPlaceholder = UIImage.init(named: "brand_placeholder.png")

var isFromEditController:Bool = false // To check is from Edit controller

var isNeedsToUpdateListing:Bool = false // To check if Iformation update on next view controler

//var userName=String()
//var userId_String=String()

let APP_NAME = "Sparky"



let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let kBASEURL             = "http://sparkyapp.softcoreindia.com/"

struct API_CONSTANT {
    //===============  Login ======================
    static let kLoginUrl            = "\(kBASEURL)users_login.php"
    static let kForgotPassword      = "\(kBASEURL)forgot_pwd.php"
    static let kUserSignup          = "\(kBASEURL)users_registration.php"
    static let kGetCatalog          = "\(kBASEURL)view_sub_category.php"
    static let kSendNotification    = "\(kBASEURL)notification.php"
    static let kUpdateProfile       = "\(kBASEURL)users_registration.php"
    static let kGetUserList         = "\(kBASEURL)view_users.php"
    static let kDeleteUser          = "\(kBASEURL)delete_users.php"
    static let kActivateUser        = "\(kBASEURL)update_users.php"
    static let kGeneratePdf         = "\(kBASEURL)generate_pdf.php"
    static let kViewProduct         = "\(kBASEURL)view_products.php"
    static let kLikeDisLikeProduct  = "\(kBASEURL)rating.php"
    static let kRateProduct         = "\(kBASEURL)comment_rating_byuser.php"
    static let kDeleteProduct       = "\(kBASEURL)delete_products.php"
    static let kGetFeedbacks        = "\(kBASEURL)comment_rating_byuser.php"
    static let kUploadProduct       = "\(kBASEURL)upload_products.php"
    static let kGenerateReport      = "\(kBASEURL)rptproduct_details.php"
    
}

struct USER_DEFAULT_CONSTANT
{
    static let KCartCounts          = "cart_counts"
    static let KCustomerActivated   = "customer_activated"
    static let KEmail               = "email"
    static let KName                = "name"
    static let KSession             = "session"
    static let kTelephone           = "tel"
    static let kUser_id             = "user_id"
    static let kWishCount           = "wishlist_counts"
    //Selected Property common
    static let KSelectedPropertyId      = "SELECTED_PROPERTY_ID"
    static let KSelectedPropertyName    = "SELECTED_PROPERTY_NAME"
}

struct NOTIFICATION_CONSTANT {
    
    static let KUserLogin              = "USER_LOGIN"
    static let KSelectProperySegment   = "SELECT_PROPERTY_NOTIF"
    static let KSelectRoomTypeSegment  = "SELECT_ROOMTYPE_NOTIF"
}




struct COLOR_HEX {
    
    static let kNavigationBar           = "#2D3290"
    static let kGreenColor              = "#76B349"
    static let kBlueColor               = "#2D3290"
    static let kRedColor                = "#E43007"
    
}

struct COLOR_CONSTANTS {
    
    static let kValidationColor = UIColor.red // Set in case of text field validation
    
    
}

struct VIEWCONTROLLER_IDENTIFIER {
    
    //User Management

    
}

// Localize Language constant



struct MESSAGE_CONSTANTS
{
    
    struct LOGIN
    {
        static let kEmailBlank          = "Please enter email."
        static let kPasswordBlank       = "Please enter password."
    }
    
    struct COMMON {
        
        static let kLogoutText              = "Do you really want to Logout?."
        static let kOk                      = "OK"
        static let kCancel                  = "CANCEL"
        
    }
    
}

