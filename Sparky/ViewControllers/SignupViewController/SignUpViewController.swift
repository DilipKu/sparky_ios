//
//  SignUpViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/10/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate
{
    //MARK: - -----APP LIFE CYCLE METHODS-------
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtUserType: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtSubmit: UIButton!
    var indentifier:String=""
    //MARK: - -----LIFE CYCLE METHODS-------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Signup"
        txtName.setBorder(placeHolder: "Name", padding: 15)
        txtEmail.setBorder(placeHolder: "Email", padding: 15)
        txtPhone.setBorder(placeHolder: "Phone", padding: 15)
        txtCity.setBorder(placeHolder: "City", padding: 15)
        txtState.setBorder(placeHolder: "State", padding: 15)
        txtUserType.setBorder(placeHolder: "Select User Type", padding: 15)
        txtUserName.setBorder(placeHolder: "Username", padding: 15)
        txtPassword.setBorder(placeHolder: "Password", padding: 15)
        txtSubmit.setButtonBorder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if self.indentifier=="Update Profile"
        {
            /*{
                address = "";
                city = "new delhi";
                "consumer_trader" = Consumer;
                email = "abc@gmail.com";
                message = "Login Successfully!!";
                name = dilip;
                password = dilip;
                phone = 9910624074;
                role = 0;
                state = "new delhi";
                status = 1;
                "user_id" = 2;
                "user_status" = Activated;
                "user_type" = Cash;
                username = dilip;
            }*/
            self.title="Update Profile"
            let dict=UserDefaults.standard.value(forKey: "userData")as! NSDictionary
            txtName.text=dict["name"]as? String
            txtEmail.text=dict["email"]as? String
            txtPhone.text=dict["phone"]as? String
            txtCity.text=dict["city"]as? String
            txtState.text=dict["state"]as? String
            txtCity.text=dict["city"]as? String
            txtUserType.text=dict["user_type"]as? String
            txtUserName.text=dict["username"]as? String
            txtPassword.text=dict["password"]as? String
            txtSubmit.setTitle("Update", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        /*
         name
         email
         phone
         city
         username
         password
         state
         consumer_trader
         registration_token_id
         */
        if self.validate()
        {
            if self.indentifier=="Update Profile"
            {
                self.updateProfile()
            }
            else
            {
                createProfile()
            }
        }
    }
    
    func updateProfile()
    {
        let userToken:String=UserDefaults.standard.value(forKey: "deviceToken") as! String
        let params=[String:String]()
        let userid = CommonFunction.getUserIdFromUserDefault()
        let queryItems =  [NSURLQueryItem(name: "user_id", value:userid),
                           NSURLQueryItem(name: "name", value:txtName.text),
                           NSURLQueryItem(name: "email", value:txtEmail.text),
                           NSURLQueryItem(name: "phone", value:txtPhone.text),
                           NSURLQueryItem(name: "city", value:txtCity.text),
                           NSURLQueryItem(name: "username", value:txtUserName.text),
                           NSURLQueryItem(name: "password", value:txtPassword.text),
                           NSURLQueryItem(name: "state", value:txtState.text),
                           NSURLQueryItem(name: "consumer_trader", value:txtUserType.text),
                           NSURLQueryItem(name: "registration_token_id", value:userToken)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kUpdateProfile)!
        
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: (URL.absoluteString), param: params)
        { (response, error) in
            print("Response=\(String(describing: response))")
            let status=response!["status"] as! Bool
            if status
            {
                let arrControllers=self.navigationController?.viewControllers
                
                let count:Int=(arrControllers?.count)!
                
                for index in 0...count
                {
                    let vc:UIViewController=arrControllers![index]
                    if vc.isKind(of: LoginViewController.self)
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                    
                    print("\(index) times 5 is \(index * 5)")
                }
                
                self.navigationController?.popViewController(animated: true)
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
    
    func createProfile()
    {
        let userToken:String=UserDefaults.standard.value(forKey: "deviceToken") as! String
        let params=[String:String]()
        let queryItems =  [NSURLQueryItem(name: "name", value:txtName.text),
                           NSURLQueryItem(name: "email", value:txtEmail.text),
                           NSURLQueryItem(name: "phone", value:txtPhone.text),
                           NSURLQueryItem(name: "city", value:txtCity.text),
                           NSURLQueryItem(name: "username", value:txtUserName.text),
                           NSURLQueryItem(name: "password", value:txtPassword.text),
                           NSURLQueryItem(name: "state", value:txtState.text),
                           NSURLQueryItem(name: "consumer_trader", value:txtUserType.text),
                           NSURLQueryItem(name: "registration_token_id", value:userToken)]
        
        let urlComps = NSURLComponents(string: API_CONSTANT.kUserSignup)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: (URL.absoluteString), param: params)
        { (response, error) in
            print("Response=\(String(describing: response))")
            let status=response!["status"] as! Bool
            if status
            {
                self.navigationController?.popViewController(animated: true)
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
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Name", inView: true)
            return false
        }
        else if txtEmail.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Email", inView: true)
            return false
        }
        else if (self.isValidEmail(testStr: txtEmail.text!)==false)
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter a valid Email", inView: true)
            return false
        }
        else if txtPhone.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Phone", inView: true)
            return false
        }
        else if txtPhone.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter Phone", inView: true)
            return false
        }
        else if txtCity.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter City", inView: true)
            return false
        }
        else if txtState.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter State", inView: true)
            return false
        }
        else if txtUserType.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Select Usertype", inView: true)
            return false
        }
        else if txtUserName.text==""
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showActionSheet()
    {
        let alert = UIAlertController(title: APP_NAME, message: "Choose a user type", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let libButton = UIAlertAction(title: "Consumer", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            self.txtUserType.text="Consumer"
        }
        
        let cancelButton = UIAlertAction(title: "Trader", style: UIAlertActionStyle.default) { (alert) -> Void in
            self.txtUserType.text="Trader"
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnShowActionSheet(_ sender: Any)
    {
        self.showActionSheet()
    }
    
    

}

extension SignUpViewController
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField==txtUserType
        {
            textField.resignFirstResponder()
            self.showActionSheet()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField==txtPhone
        {
            let textstring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length = textstring.characters.count
            if length > 10
            {
                return false
            }
            return true
        }
        return true
    }
}
