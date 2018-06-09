//
//  CatalogListViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/11/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class CatalogListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet weak var tblCatalog: UITableView!
    var arrItems=[Catalog]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title="Catalog"
        self.getCatalog()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCatalog()
    {
        let params=[String:String]()
        //let userid = CommonFunction.getUserIdFromUserDefault()
        let queryItems = [NSURLQueryItem(name: " cat_id", value:"1")]
        let urlComps = NSURLComponents(string: API_CONSTANT.kGetCatalog)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            let status=response!["status"] as! Bool
            if status
            {
                let arrayBanner = response!["Sub Category Details"] as! NSArray
                if arrayBanner.count>0
                {
                    for dic in arrayBanner
                    {
                        let tempDic = dic as! NSDictionary
                        self.arrItems.append(Catalog(dict: tempDic));
                        self.tblCatalog.reloadData()
                    }
                    
                }
            }
            else
            {
                
            }
        }
    }

}

extension CatalogListViewController
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
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "ViewProductViewController")as! ViewProductViewController
        vc.cat_id=arrItems[indexPath.row].cat_id
        vc.prd_id=arrItems[indexPath.row].id
        vc.prd_title=arrItems[indexPath.row].sub_cat_title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
