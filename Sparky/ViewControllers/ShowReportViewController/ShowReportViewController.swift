//
//  ShowReportViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/23/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class ShowReportViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtSelectType: UITextField!
    @IBOutlet weak var btnDownloadPdf: UIButton!
    var activeTextField:UITextField?=nil
    var gradePicker: UIPickerView!
    var arrItems=[Catalog]()
    var PickerIndex:Int=0
    var documentController : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Show Report"
        txtSelectType.setBorder(placeHolder: "Select", padding: 15)
        txtFromDate.setBorder(placeHolder: "From Date", padding: 15)
        txtToDate.setBorder(placeHolder: "To Date", padding: 15)
        btnDownloadPdf.layer.cornerRadius=8
        self.getCatalog()
        // Do any additional setup after loading the view.
        let datePicker: UIDatePicker = UIDatePicker()
        
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        txtFromDate.inputView=datePicker
        txtToDate.inputView=datePicker
        
        //--------------------------
        gradePicker = UIPickerView()
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        
       
        txtSelectType.inputView = gradePicker
        
        
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
                        
                    }
                    self.gradePicker.reloadInputViews()
                }
            }
            else
            {
                
            }
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        activeTextField?.text=selectedDate
        print("Selected value \(selectedDate)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDownloadPdfAction(_ sender: Any)
    {
             //http://sparkyapp.softcoreindia.com/rptproduct_details.php?sub_cat_id=1&from_date=01-01-2018&to_date=20-02-2018
        if self.validate()
        {
            let params=[String:String]()
            //let userid = CommonFunction.getUserIdFromUserDefault()
            let queryItems = [NSURLQueryItem(name: "cat_id", value:arrItems[PickerIndex].cat_id),
                              NSURLQueryItem(name: "from_date", value:txtFromDate.text),
                              NSURLQueryItem(name: "to_date", value:txtToDate.text)]
            let urlComps = NSURLComponents(string: API_CONSTANT.kGenerateReport)!
            urlComps.queryItems = queryItems as [URLQueryItem]
            let URL = urlComps.url!
            SparkyApiHelper.apiCallDownloadPdf(serviceName:URL.absoluteString, param:params)
            { (fileUrl, error) in
                print(fileUrl ?? "")
                
                self.documentController = UIDocumentInteractionController.init(url: fileUrl!)
                
                self.documentController.name = fileUrl?.lastPathComponent
                
                self.documentController.delegate = self
                
                self.documentController.presentPreview(animated: true)
                
//                self.navigationController?.navigationBar.tintColor = UIColor.red
            }
        }
        
        
    }
    
    func validate() -> Bool
    {
        if txtFromDate.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter from date", inView: true)
            return false
        }
        else if txtToDate.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Enter to date", inView: true)
            return false
        }
        else if txtSelectType.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Please select a category", inView: true)
            return false
        }
        else
        {
            return true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField=textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField=nil
    }
    
    //MARK: - ---------PICKERVIEW DATASOURCES----------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return arrItems[row].sub_cat_title
        
        
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
            return arrItems.count
       
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            PickerIndex=row
            txtSelectType.text =  arrItems[row].sub_cat_title
        
        
        //gradeTextField.text = gradePickerValues[row]
        //sub_cat_idself.view.endEditing(true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
//        UINavigationBar.appearance().barTintColor = UIColor.red
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)]
        self.navigationController?.delegate=self
        return self
       
        
    }
    
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        //APP_DELEGATE.window?.tintColor = UIColor.white
        self.documentController = nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
    {
        
        
//        UINavigationBar.appearance().barTintColor = UIColor.red
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)]
    }
    

}
