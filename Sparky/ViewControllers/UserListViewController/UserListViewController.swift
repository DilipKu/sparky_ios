//
//  UserListViewController.swift
//  DemoSp
//
//  Created by VISHAL SETH on 21/02/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell
{
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblUserStatus: UILabel!
    @IBOutlet weak var btnSelectUserType: UIButton!
    @IBOutlet weak var btnActicateUser: UIButton!
    
    
}

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var tblUserList: UITableView!
    var arrUsers=[UserListModel]()
    var documentController : UIDocumentInteractionController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="User List"
        getList()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectUserType(sender:UIButton)
    {
        let tag:Int=sender.tag
        self.showAlertUserType(index: tag)
    }
    
    @objc func activateUser(sender:UIButton)
    {
        let tag:Int=sender.tag
        self.showActivationAlert(index:tag)
    }
    
    func showAlertUserType(index:Int)
    {
        let alert = UIAlertController(title: APP_NAME, message: "Choose a user type", preferredStyle: UIAlertControllerStyle.alert)
        
        let cashButton = UIAlertAction(title: "Cash", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            //self.txtUserType.text="Consumer"
            let UData:UserListModel=self.arrUsers[index]
            UData.user_type="Cash"
            self.arrUsers[index]=UData
            self.tblUserList.reloadData()
        }
        
        let creditButton = UIAlertAction(title: "Credit", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            let UData:UserListModel=self.arrUsers[index]
            UData.user_type="Credit"
            self.arrUsers[index]=UData
            self.tblUserList.reloadData()
            //self.txtUserType.text="Consumer"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (alert) -> Void in
            //self.txtUserType.text="Trader"
        }
        
        alert.addAction(cashButton)
        alert.addAction(creditButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivationAlert(index:Int)
    {
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure to activate this user ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cashButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            if (self.arrUsers[index].user_type=="" || self.arrUsers[index].user_type=="Select")
            {
                showErrorBanner(titleString: APP_NAME, subtitleString: "Please select a user type", inView: true)
            }
            else
            {
                self.acticateUser(indexx: index)
            }
            //self.txtUserType.text="Consumer"
        }
        
        let creditButton = UIAlertAction(title: "NO", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            //self.txtUserType.text="Consumer"
        }
        
        alert.addAction(cashButton)
        alert.addAction(creditButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRemoveUser(indexxx:Int)
    {
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure to remove this user ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cashButton = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (alert) -> Void in
            self.removeUser(indexx:indexxx)
            //self.txtUserType.text="Consumer"
            
        }
        
        let creditButton = UIAlertAction(title: "NO", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            //self.txtUserType.text="Consumer"
        }
        
        alert.addAction(cashButton)
        alert.addAction(creditButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUserDetailorDeleteAlert(index:Int)
    {
        let alert = UIAlertController(title: APP_NAME, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cashButton = UIAlertAction(title: "Remove", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            //self.txtUserType.text="Consumer"
            self.showRemoveUser(indexxx: index)
        }
        
        let creditButton = UIAlertAction(title: "Show detail", style: UIAlertActionStyle.default) { (alert) -> Void in
            
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController")as!UserDetailsViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            vc.arrUserData=[self.arrUsers[index]]
            self.present(vc, animated: true, completion: nil)
            //self.txtUserType.text="Consumer"
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (alert) -> Void in
            //self.txtUserType.text="Trader"
        }
        
        alert.addAction(cashButton)
        alert.addAction(creditButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDownLoadPdfAction(_ sender: Any)
    {
        let params=[String:String]()
        SparkyApiHelper.apiCallDownloadPdf(serviceName: API_CONSTANT.kGeneratePdf, param:params)
        { (fileUrl, error) in
            print(fileUrl ?? "")
            
            self.documentController = UIDocumentInteractionController.init(url: fileUrl!)
            
            self.documentController.name = fileUrl?.lastPathComponent
            
            self.documentController.delegate = self
            
            self.documentController.presentPreview(animated: true)
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }
    
    //MARK: - ------GET USRE LIST------
    
    func acticateUser(indexx:Int)
    {
        let userID:String = arrUsers[indexx].id
        let userType:String = arrUsers[indexx].user_type
        //let userStatus:String = arrUsers[indexx].user_status
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "user_id", value:userID),
                          NSURLQueryItem(name: "user_type", value:userType),
                          NSURLQueryItem(name: "user_status", value:"Activated")]
        let urlComps = NSURLComponents(string: API_CONSTANT.kActivateUser)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            let success=response!["status"]as! Bool
            if success
            {
                self.arrUsers.removeAll()
                self.getList()
            }
            else
            {
                let msg=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
            }
        }
    }
    
    
    func removeUser(indexx:Int)
    {
        let userID:String = arrUsers[indexx].id
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "user_id", value:userID)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kDeleteUser)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            let success=response!["status"]as! Bool
            if success
            {
                self.arrUsers.removeAll()
                self.getList()
            }
            else
            {
                let msg=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
            }
        }
    }
    
    func getList()
    {
        let params=[String:String]()
        SparkyApiHelper.apiCall(serviceName: API_CONSTANT.kGetUserList, param: params)
        { (response, error) in
            let success=response!["status"]as! Bool
            if success
            {
                let arraymenu = response?["Users"] as! NSArray
                for dic in arraymenu
                {
                    let tempDic = dic as! NSDictionary
                    self.arrUsers.append(UserListModel(dict: tempDic));
                    self.tblUserList.reloadData()
                }
            }
            else
            {
                let msg=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: msg, inView: true)
            }
        }
    }
    
}

extension UserListViewController
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UserListCell=tableView.dequeueReusableCell(withIdentifier: "UserListCell") as! UserListCell
        cell.btnSelectUserType.addTarget(self, action: #selector(self.selectUserType(sender:)), for: .touchUpInside)
        cell.btnActicateUser.addTarget(self, action: #selector(self.activateUser(sender:)), for: .touchUpInside)
        cell.btnSelectUserType.tag=indexPath.row
        cell.btnActicateUser.tag=indexPath.row
        cell.lblSerialNo.text=String(indexPath.row+1)
        cell.lblUserName.text=arrUsers[indexPath.row].name
        cell.btnSelectUserType.setTitle(arrUsers[indexPath.row].user_type, for: .normal)
        cell.btnActicateUser.setTitle(arrUsers[indexPath.row].user_status, for: .normal)
        cell.btnActicateUser.isUserInteractionEnabled=false
        cell.btnSelectUserType.isUserInteractionEnabled=false
        cell.btnSelectUserType.setTitleColor(UIColor.darkGray, for: .normal)
        if arrUsers[indexPath.row].user_status==""
        {
            cell.btnSelectUserType.setTitleColor(UIColor.black, for: .normal)
            cell.btnSelectUserType.isUserInteractionEnabled=true
            
            cell.btnActicateUser.isUserInteractionEnabled=true
            cell.btnActicateUser.setTitle("Pending", for: .normal)
        }
        if arrUsers[indexPath.row].user_type==""
        {
            cell.btnSelectUserType.isUserInteractionEnabled=true
            cell.btnSelectUserType.setTitle("Select", for: .normal)
            cell.btnSelectUserType.setTitleColor(UIColor.black, for: .normal)
        }
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.showUserDetailorDeleteAlert(index:indexPath.row)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        
        
        return self
    }
    
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        self.documentController = nil
    }
}

class UserListModel: NSObject
{
    var id:String=""
    var name:String=""
    var email:String=""
    var phone:String=""
    var orgranisation:String=""
    var city:String=""
    var address:String=""
    var password:String=""
    var role:String=""
    var user_type:String=""
    var user_status:String=""
    var state:String=""
    var consumer_trade:String=""
    var registration_token:String=""
    
    
    init(dict:NSDictionary)
    {
         id=dict["id"]as! String
         name=dict["name"]as! String
         email=dict["email"]as! String
         phone=dict["phone"]as! String
         orgranisation=dict["organisation"]as! String
         city=dict["city"]as! String
         address=dict["address"]as! String
         password=dict["password"]as! String
         role=dict["role"]as! String
         user_type=dict["user_type"]as! String
         user_status=dict["user_status"]as! String
         state=dict["state"]as! String
         consumer_trade=dict["consumer_trader"]as! String
         registration_token=dict["registration_token_id"]as! String
    }
}

