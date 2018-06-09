//
//  ContactUsPopupViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/20/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class ContactUsPopupViewController: UIViewController {

    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius=10
        btnSubmit.layer.cornerRadius=10
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
