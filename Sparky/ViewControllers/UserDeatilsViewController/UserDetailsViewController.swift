//
//  UserDetailsViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 21/02/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    var arrUserData=[UserListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text=arrUserData[0].name
        lblCity.text=arrUserData[0].city
        lblEmail.text=arrUserData[0].email
        lblPhone.text=arrUserData[0].phone
        viewPopup.layer.cornerRadius=10
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOkAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
