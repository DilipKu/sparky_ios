//
//  CategoryListViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/10/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit
class CategoryCell: UITableViewCell
{
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var viewItem: UIView!
}

class CategoryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblCategory: UITableView!
    let arrItems=["Catalog","Upload Article","User List","Send Notification","Update Mobile no","Show Report","Show Feedback","Logout"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title="Admin"
        self.setBgColor()
        self.tblCategory.setBgColor()
        tblCategory.reloadData()
        self.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - --------CUSTOM METHODS------
    func showUpdateMobile()
    {
        let alertController = UIAlertController(title: "Sparky", message: "Update Mobile Number", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Mobile Number"
            textField.keyboardType=UIKeyboardType.phonePad
           
        })
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Current password \(String(describing: alertController.textFields?[0].text))")
            //compare the current password and do action here
        })
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showNotoficationPopup()
    {
        let alertController = UIAlertController(title: "Sparky", message: "Do you want to send notification ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
           self.sendNotification()
            //compare the current password and do action here
        })
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    func showLogoutPopup()
    {
        let alertController = UIAlertController(title: "Sparky", message: "Are you sure to logout ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            UserDefaults.standard.set(nil, forKey: "userData")
            UserDefaults.standard.synchronize()
            //compare the current password and do action here
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func sendNotification()
    {
        let params=[String:String]()
        
        SparkyApiHelper.apiCall(serviceName: API_CONSTANT.kSendNotification, param: params)
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
    


}

extension CategoryListViewController
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CategoryCell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell")as! CategoryCell
        cell.viewItem.layer.borderColor=UIColor.white.cgColor
        cell.viewItem.layer.borderWidth=1.0
        cell.viewItem.layer.cornerRadius=5
        cell.viewItem.clipsToBounds=true
        cell.lblItemName.text=arrItems[indexPath.row]
        cell.backgroundColor=UIColor.clear
        cell.contentView.backgroundColor=UIColor.clear
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row==0
        {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "CatalogListViewController")as! CatalogListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row==1
        {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "UploadArticleViewController")as! UploadArticleViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row==2
        {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "UserListViewController")as! UserListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row==3
        {
            self.showNotoficationPopup()
        }
        else if indexPath.row==4
        {
            self.showUpdateMobile()
        }
        else if indexPath.row==5
        {
            //self.showUpdateMobile()report
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "ShowReportViewController")as! ShowReportViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row==6
        {
            //self.showUpdateMobile()feedback
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "AllRatingViewController")as! AllRatingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row==7
        {
            self.showLogoutPopup()
        }
    }
}
