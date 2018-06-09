//
//  AllRatingViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/22/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class FeedbackCell: UITableViewCell
{
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblComment: UILabel!
}

class AllRatingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblFeedback: UITableView!
    var arrFeedbacks=[FeedbackModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="User Feedback"
        self.getFeedbacks()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getFeedbacks()
    {
        // http://sparkyapp.softcoreindia.com/comment_rating_byuser.php
        
        let params=[String:String]()
        
        SparkyApiHelper.apiCall(serviceName: API_CONSTANT.kGetFeedbacks, param: params) { (response, error) in
            
            let status=response!["status"]as! Bool
            if status
            {
                let arraymenu = response?["Comments"] as! NSArray
                for dic in arraymenu
                {
                    let tempDic = dic as! NSDictionary
                    self.arrFeedbacks.append(FeedbackModel(dict: tempDic));
                }
                self.tblFeedback.reloadData()
            }
            else
            {
                let message=response!["message"]as! String
                showErrorBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
        }
    }

}

extension AllRatingViewController
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrFeedbacks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "FeedbackCell")as! FeedbackCell
        cell.viewMain.layer.borderWidth=1.0
        cell.viewMain.layer.borderColor=UIColor.white.cgColor
        cell.viewMain.layer.cornerRadius=7
        cell.lblUserName.text=arrFeedbacks[indexPath.row].username
        cell.lblPhone.text=arrFeedbacks[indexPath.row].phone
        
        let rate:String=arrFeedbacks[indexPath.row].rate_star
        let comment:String=arrFeedbacks[indexPath.row].user_comment
        
        cell.lblRating.text = rate+"Star"
        cell.lblComment.text="Comment:"+comment
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        return cell
    }
}



class FeedbackModel: NSObject
{
    var username:String=""
    var phone:String=""
    var rate_star:String=""
    var user_comment:String=""
    init(dict:NSDictionary)
    {
        username=dict["username"]as! String
        phone=dict["phone"]as! String
        rate_star=dict["rate_star"]as! String
        user_comment=dict["users_comment"]as! String
    }
}
