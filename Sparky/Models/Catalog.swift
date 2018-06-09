//
//  Catalog.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/17/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class Catalog: NSObject
{
    //{"id":"1","cat_id":"1","sub_cat_title":"Denim","status":"1"}
    var id=""
    var cat_id=""
    var sub_cat_title=""
    var status=""
    init(dict:NSDictionary)
    {
        id=dict["id"] as! String
        cat_id=dict["cat_id"] as! String
        sub_cat_title=dict["sub_cat_title"] as! String
        status=dict["status"] as! String
    }
}
