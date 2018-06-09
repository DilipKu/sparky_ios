//
//  CategoryUserViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/17/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class CategoryUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tblCategory: UITableView!
    var arrItems=[CatalogData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCategory.backgroundColor=UIColor.clear
        tblCategory.setBgColor()
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.title="HOME"
        self.getCategory()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func getCategory()
    {
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "cat_id", value: "1")]
        let urlComps = NSURLComponents(string: API_CONSTANT.kGetCatalog)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            let status=response!["status"]as! Bool
            if status
            {
                let arraymenu = response?["Sub Category Details"] as! NSArray
                
                for dic in arraymenu
                {
                    let tempDic = dic as! NSDictionary
                    self.arrItems.append(CatalogData(dict: tempDic));
                    self.tblCategory.reloadData()
                }
                
                var arrExtraData=[NSDictionary]()
                var dict=[String:String]()
                dict.updateValue("", forKey: "id")
                dict.updateValue("", forKey: "cat_id")
                dict.updateValue("Update Profile", forKey: "sub_cat_title")
                dict.updateValue("", forKey: "status")
                
                var dict1=[String:String]()
                dict1.updateValue("", forKey: "id")
                dict1.updateValue("", forKey: "cat_id")
                dict1.updateValue("Contact Us", forKey: "sub_cat_title")
                dict1.updateValue("", forKey: "status")
                
                var dict2=[String:String]()
                dict2.updateValue("", forKey: "id")
                dict2.updateValue("", forKey: "cat_id")
                dict2.updateValue("Invite Your Friends", forKey: "sub_cat_title")
                dict2.updateValue("", forKey: "status")
                
                var dict3=[String:String]()
                dict3.updateValue("", forKey: "id")
                dict3.updateValue("", forKey: "cat_id")
                dict3.updateValue("Feedback", forKey: "sub_cat_title")
                dict3.updateValue("", forKey: "status")
                
                var dict4=[String:String]()
                dict4.updateValue("", forKey: "id")
                dict4.updateValue("", forKey: "cat_id")
                dict4.updateValue("Logout", forKey: "sub_cat_title")
                dict4.updateValue("", forKey: "status")
                
                arrExtraData.append(dict as NSDictionary)
                arrExtraData.append(dict1 as NSDictionary)
                arrExtraData.append(dict2 as NSDictionary)
                arrExtraData.append(dict3 as NSDictionary)
                arrExtraData.append(dict4 as NSDictionary)
                
                for dic in arrExtraData
                {
                    let tempDic = dic
                    self.arrItems.append(CatalogData(dict: tempDic));
                    self.tblCategory.reloadData()
                }
            }
            else
            {
                let message=response!["message"] as! String
                showErrorBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
            
        }
    }

}

extension CategoryUserViewController
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
        cell.lblItemName.text=arrItems[indexPath.row].sub_cat_title
        cell.backgroundColor=UIColor.clear
        cell.contentView.backgroundColor=UIColor.clear
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row<6
        {
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "ViewProductViewController")as! ViewProductViewController
            vc.cat_id=arrItems[indexPath.row].cat_id
            vc.prd_id=arrItems[indexPath.row].id
            vc.prd_title=arrItems[indexPath.row].sub_cat_title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if arrItems[indexPath.row].sub_cat_title=="Logout"
            {
                self.showLogoutPopup()
            }
            else if arrItems[indexPath.row].sub_cat_title=="Feedback"
            {
                //showSuccessBanner(titleString: APP_NAME, subtitleString: "This Feature will work after live", inView: true)
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController")as!RatingViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }
            else if arrItems[indexPath.row].sub_cat_title=="Contact Us"
            {
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "ContactUsPopupViewController")as!ContactUsPopupViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }
            else if arrItems[indexPath.row].sub_cat_title=="Invite Your Friends"
            {
                
                let url = "www.google.com"
                let activityViewController = UIActivityViewController(
                    activityItems: ["Check Out new clothing", url],
                    applicationActivities: nil)
                if activityViewController.popoverPresentationController != nil {
                    
                }
                present(activityViewController, animated: true, completion: nil)
            }
            else if arrItems[indexPath.row].sub_cat_title=="Update Profile"
            {
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
                vc.indentifier="Update Profile"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

class CatalogData: NSObject
{
    var id:String=""
    var cat_id:String=""
    var sub_cat_title:String=""
    var status:String=""
    init(dict:NSDictionary)
    {
        id=dict["id"]as! String
        cat_id=dict["cat_id"]as! String
        sub_cat_title=dict["sub_cat_title"]as! String
        status=dict["status"]as! String
    }
}
