//
//  LoginViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/10/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    //MARK: - ------LIFE CYCLE METHODS-----
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.setBorder(placeHolder: "Username", padding: 35)
        txtPassword.setBorder(placeHolder: "Password", padding: 35)
        btnLogin.setButtonBorder()
        self.setBgColor()
        self.title="Login"
        
        
        if let dict:NSDictionary=UserDefaults.standard.value(forKey: "userData") as? NSDictionary
       {
        if dict.count>0
        {
            let usertype=dict["role"]as! String
            if (usertype=="1")
            {
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "CategoryListViewController") as! CategoryListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "CategoryUserViewController") as! CategoryUserViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        }
        else
       {
        
        }
        
    
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUpdateMobile()
    {
        let alertController = UIAlertController(title: "Sparky", message: "Enter registered mobile number", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Mobile Number"
            textField.keyboardType=UIKeyboardType.phonePad
            
        })
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Current password \(String(describing: alertController.textFields?[0].text))")
            self.callForgotPassword(text: (alertController.textFields?[0].text)!)
            //compare the current password and do action here
        })
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func callForgotPassword(text:String)
    {
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "phone", value:text)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kForgotPassword)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            print("Response=\(String(describing: response))")
            let status=response!["status"] as! Bool
            if status
            {
                let msg=response!["message"] as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
            }
            else
            {
                let msg=response!["message"] as! String
                showErrorBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
            }
        }
    }
    
    
    func validate() -> Bool
    {
        if txtName.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Username", inView: true)
            return false
        }
        else if txtPassword.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Password", inView: true)
            return false
        }
        else
        {
            return true
        }
    }

    //MARK: - ----BUTTONS ACTIONS------
    
    @IBAction func btnLoginAction(_ sender: Any)
    {
        if validate()
        {
            let params=[String:String]()
            let queryItems = [NSURLQueryItem(name: "username", value: txtName.text), NSURLQueryItem(name: "password", value:txtPassword.text)]
            let urlComps = NSURLComponents(string: API_CONSTANT.kLoginUrl)!
            urlComps.queryItems = queryItems as [URLQueryItem]
            let URL = urlComps.url!
            
            SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
            { (response, error) in
                print("Response=\(String(describing: response))")
                let status=response!["status"] as! Bool
                if status
                {
                    self.txtName.text=""
                    self.txtPassword.text=""
                    let msg=response!["message"] as! String
                    showSuccessBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
                    let usertype=response!["role"]as! String
                    UserDefaults.standard.set(response, forKey: "userData")
                    UserDefaults.standard.synchronize()
                    if (usertype=="1")
                    {
                        let vc=self.storyboard?.instantiateViewController(withIdentifier: "CategoryListViewController") as! CategoryListViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let vc=self.storyboard?.instantiateViewController(withIdentifier: "CategoryUserViewController") as! CategoryUserViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else
                {
                    let msg=response!["message"] as! String
                    showErrorBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
                }
            }
        }
        
    }
    
    @IBAction func btnForgotPassword(_ sender: Any)
    {
        showUpdateMobile()
    }
    
    @IBAction func btnSignupAction(_ sender: Any)
    {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
