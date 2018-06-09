//
//  RatingViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/22/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController,FloatRatingViewDelegate,UITextViewDelegate {

    
    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblFeedbackRank: UILabel!
    @IBOutlet weak var txtViewReview: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var ratingNumber:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius=10
        viewPopup.clipsToBounds=true
        btnCancel.layer.cornerRadius=5
        btnSubmit.layer.cornerRadius=5
        txtViewReview.layer.cornerRadius=5
        txtViewReview.layer.borderWidth=1.0
        txtViewReview.layer.borderColor=UIColor.darkGray.cgColor
        
        viewRating.backgroundColor = UIColor.clear
        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        viewRating.delegate = self
        viewRating.contentMode = UIViewContentMode.scaleAspectFit
        viewRating.type = .halfRatings
        
        ratingNumber = String(format: "%.2f", self.viewRating.rating)
        // Segmented control init
        
        if self.viewRating.rating>4
        {
            lblFeedbackRank.text="Excellent"
        }
        else if self.viewRating.rating>3
        {
            lblFeedbackRank.text="Good"
        }
        else if self.viewRating.rating>2
        {
            lblFeedbackRank.text="Average"
        }
        else if self.viewRating.rating>=1
        {
            lblFeedbackRank.text="Not Liked"
        }
        // Labels init
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        
        var comment:String=""
        if txtViewReview.text=="Write a review (optional)"
        {
            comment=""
        }
        else
        {
            comment=txtViewReview.text
        }
        let userid:String=CommonFunction.getUserIdFromUserDefault()
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "user_id", value:userid),
                          NSURLQueryItem(name: "rate_star", value:ratingNumber),
                          NSURLQueryItem(name: "users_comment", value:comment)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kRateProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            print("Response=\(String(describing: response))")
            let status=response!["status"] as! Bool
            if status
            {
                self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func btnCancelAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text=="Write a review (optional)"
        {
            textView.text=""
            textView.textColor=UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text==""
        {
            textView.textColor=UIColor.darkGray
            textView.text="Write a review (optional)"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text=="\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }
}

extension RatingViewController {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        ratingNumber = String(format: "%.2f", self.viewRating.rating)
        if self.viewRating.rating>4
        {
            lblFeedbackRank.text="Excellent"
        }
        else if self.viewRating.rating>3
        {
            lblFeedbackRank.text="Good"
        }
        else if self.viewRating.rating>2
        {
            lblFeedbackRank.text="Average"
        }
        else if self.viewRating.rating>=1
        {
            lblFeedbackRank.text="Not Liked"
        }
       // liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        ratingNumber = String(format: "%.2f", self.viewRating.rating)
        if self.viewRating.rating>4
        {
            lblFeedbackRank.text="Excellent"
        }
        else if self.viewRating.rating>3
        {
            lblFeedbackRank.text="Good"
        }
        else if self.viewRating.rating>2
        {
            lblFeedbackRank.text="Average"
        }
        else if self.viewRating.rating>=1
        {
            lblFeedbackRank.text="Not Liked"
        }
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}

