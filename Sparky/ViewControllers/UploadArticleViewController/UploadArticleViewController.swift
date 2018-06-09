//
//  UploadArticleViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/11/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit

class UploadArticleViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewMain: UIView!
    //-------------------------------------
    @IBOutlet weak var txtArticleNo: UITextField!
    @IBOutlet weak var txtItemDescription: UITextField!
    @IBOutlet weak var txtRate: UITextField!
    @IBOutlet weak var txtCatalog: UITextField!
    @IBOutlet weak var txtDressType: UITextField!
    var gradePicker: UIPickerView!
    let gradePickerValues = ["Catalog"]
    var arrItems=[Catalog]()
    var activeTextfields:UITextField?=nil
    //-------------------------------------
    var arrProductImages=[UIImage]()
    var SelectedImage:UIImage? = nil
    let picker = UIImagePickerController()
    var selectedIndex:Int=0
    var PickerIndex:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.title="Upload Article"
        self.getCatalog()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize=CGSize.init(width: self.view.frame.size.width, height: viewMain.frame.origin.y+viewMain.frame.size.height+20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup()
    {
        let cellWidth : CGFloat = self.view.frame.size.width-40
        let cellheight : CGFloat = self.collectionSlider.frame.height
        let cellSize = CGSize(width: cellWidth , height:cellheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 2)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionSlider.setCollectionViewLayout(layout, animated: true)
        collectionSlider.isPagingEnabled=true
        collectionSlider.layer.borderWidth=1.0
        collectionSlider.layer.borderColor=UIColor.lightGray.cgColor
        collectionSlider.layer.cornerRadius=8
        collectionSlider.reloadData()
        
        btnCamera.layer.borderWidth=1.0
        btnCamera.layer.borderColor=UIColor.lightGray.cgColor
        btnCamera.layer.cornerRadius=8
        
        btnGallery.layer.borderWidth=1.0
        btnGallery.layer.borderColor=UIColor.lightGray.cgColor
        btnGallery.layer.cornerRadius=8
        
        btnSubmit.layer.borderColor=UIColor.lightGray.cgColor
        btnSubmit.layer.cornerRadius=5
        
        btnCancel.layer.borderColor=UIColor.lightGray.cgColor
        btnCancel.layer.cornerRadius=5
        
        txtRate.setBlackBorder(placeHolder: "Rate", padding: 15)
        txtCatalog.setBlackBorder(placeHolder: "Catalog", padding: 15)
        txtArticleNo.setBlackBorder(placeHolder: "Article No", padding: 15)
        txtItemDescription.setBlackBorder(placeHolder: "Item Description", padding: 15)
        txtDressType.setBlackBorder(placeHolder: "", padding: 15)
        
        //----------
        gradePicker = UIPickerView()
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        
        txtCatalog.inputView = gradePicker
        txtDressType.inputView = gradePicker
        
        txtCatalog.text=gradePickerValues[0]
        
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        uploadProductProduct()
    }
    
    @IBAction func btnCancelAction(_ sender: Any)
    {
        self.arrProductImages.removeAll()
        self.collectionSlider.reloadData()
        self.txtRate.text=""
        self.txtArticleNo.text=""
        self.txtDressType.text=""
    }
    
    
    @IBAction func btnGalleryAction(_ sender: Any)
    {
        self.openGallery()
    }
    
    @IBAction func btnCameraAction(_ sender: Any)
    {
        self.openCamera()
    }
    
    
    func openCamera()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.delegate=self
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
        
    }
    
    func openGallery()
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate=self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func showActionSheet()
    {
        let alert = UIAlertController(title: APP_NAME, message: "Browse image using", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let GalleryButton = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (alert) -> Void in
            self.openGallery()
        }
        
        let CameraButton = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (alert) -> Void in
            self.openCamera()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (alert) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(GalleryButton)
        alert.addAction(CameraButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
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
                    self.picker.reloadInputViews()
                }
            }
            else
            {
                
            }
        }
    }
    
    //-------------------------------
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfields=textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextfields=nil
    }
    
    func validate() -> Bool
    {
        if txtArticleNo.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Please enter article number", inView: true)
            return false
        }
        else if txtItemDescription.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Please enter description", inView: true)
            return false
        }
        else if txtRate.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Please enter rate", inView: true)
            return false
        }
        else if txtCatalog.text==""
        {
            showErrorBanner(titleString: APP_NAME, subtitleString: "Please select catalog", inView: true)
            return false
        }
        else
        {
            return true
        }
        
    }
    
    func uploadProductProduct()
    {
         /*
         cat_id
         sub_cat_id
         item_code
         item_description
         rate
         quantity
         front_prd_img
         side_prd_img
         back_prd_img
         */
        var front_prd_img:String=""
        var side_prd_img:String=""
        var back_prd_img:String=""
        if self.validate()
        {
            if arrProductImages.count>0
            {
                if arrProductImages.count==1
                {
                    let header:String="data:image/png;base64,"
                    let imageData = UIImageJPEGRepresentation(arrProductImages[0], 0.6)
                    let base64 = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
                    front_prd_img=header+base64
                    
//                    let imageData = UIImageJPEGRepresentation(arrProductImages[0], 0.6)
//                    front_prd_img = (imageData?.base64EncodedString(options: .lineLength64Characters))!
                }
                else if arrProductImages.count==2
                {
                    let header:String="data:image/png;base64,"
                    let imageData = UIImageJPEGRepresentation(arrProductImages[1], 0.6)
                    let base64 = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
                    side_prd_img=header+base64
                    
//                    let imageData = UIImageJPEGRepresentation(arrProductImages[1], 0.6)
//                    side_prd_img = (imageData?.base64EncodedString(options: .lineLength64Characters))!
                }
                else if arrProductImages.count==3
                {
                   // NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                    //base64=[NSString stringWithFormat:@"data:image/png;base64,%@",base64];
                    let header:String="data:image/png;base64,"
                    let imageData = UIImageJPEGRepresentation(arrProductImages[2], 0.6)
                    let base64 = (imageData?.base64EncodedString(options:.endLineWithLineFeed))!
                    back_prd_img=header+base64
                }
                
                //NSURLQueryItem(name: "front_prd_img", value:front_prd_img),
               // NSURLQueryItem(name: "side_prd_img", value:side_prd_img),
                //NSURLQueryItem(name: "back_prd_img", value:back_prd_img)
                
//                let params=[String:String]()
//                //let userid = CommonFunction.getUserIdFromUserDefault()
//                let queryItems = [NSURLQueryItem(name: "cat_id", value:"1"),
//                                  NSURLQueryItem(name: "sub_cat_id", value:arrItems[0].cat_id),
//                                  NSURLQueryItem(name: "item_description", value:txtItemDescription.text),
//                                  NSURLQueryItem(name: "rate", value:txtRate.text),
//                                  NSURLQueryItem(name: "quantity", value:"1")]
//                let urlComps = NSURLComponents(string: API_CONSTANT.kUploadProduct)!
//                urlComps.queryItems = queryItems as [URLQueryItem]
//                let URL = urlComps.url!
                
                
                var newparams=[String:String]()
                newparams.updateValue("1", forKey: "cat_id")
                newparams.updateValue(arrItems[selectedIndex].id, forKey: "sub_cat_id")
                newparams.updateValue(txtItemDescription.text!, forKey: "item_description")
                newparams.updateValue(txtRate.text!, forKey: "rate")
                newparams.updateValue("1", forKey: "quantity")
                
                
                
                SparkyApiHelper.apiCallWithImageAndVideos(serviceName: API_CONSTANT.kUploadProduct, image: arrProductImages as NSArray, video: arrProductImages as NSArray, param: newparams, completionClosure:
                {
                (response, error) in
                    let status=response!["status"] as! Bool
                    if status
                    {
                        let message=response!["message"]as! String
                        showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
                        self.arrProductImages.removeAll()
                        self.collectionSlider.reloadData()
                        self.txtRate.text=""
                        self.txtArticleNo.text=""
                        self.txtDressType.text=""
                    }
                    else
                    {
                        let message=response!["message"]as! String
                        showErrorBanner(titleString: APP_NAME, subtitleString: message, inView: true)
                    }
                })
                
                
                
                
                
                /*
                
                SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
                { (response, error) in
                    let status=response!["status"] as! Bool
                    if status
                    {
                        let message=response!["message"]as! String
                        showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
                        self.arrProductImages.removeAll()
                        self.collectionSlider.reloadData()
                        self.txtRate.text=""
                        self.txtArticleNo.text=""
                        self.txtDressType.text=""
                    }
                    else
                    {
                        let message=response!["message"]as! String
                        showErrorBanner(titleString: APP_NAME, subtitleString: message, inView: true)
                    }
                }
 */
            }
            else
            {
                showErrorBanner(titleString: APP_NAME, subtitleString: "Choose an image first", inView: true)
            }
        }

        
        
    }
    

}

extension UploadArticleViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:SliderCell=collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        if arrProductImages.count>indexPath.item
        {
            cell.imgSlider.image=arrProductImages[indexPath.item]
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndex=indexPath.item
        if arrProductImages.count==3
        {
            self.showActionSheet()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        SelectedImage = chosenImage
        if arrProductImages.count==3
        {
            arrProductImages[selectedIndex]=SelectedImage!
        }
        else
        {
            arrProductImages.append(SelectedImage!)
        }
        
        self.collectionSlider.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ---------PICKERVIEW DATASOURCES----------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextfields==txtDressType
        {
            return arrItems[row].sub_cat_title
        }
        else
        {
            return gradePickerValues[row]
        }
        
    }
    
    
   
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if activeTextfields==txtDressType
        {
            return arrItems.count
        }
        else
        {
             return gradePickerValues.count
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextfields==txtDressType
        {
            PickerIndex=row
            txtDressType.text =  arrItems[row].sub_cat_title
        }
        else
        {
            txtCatalog.text = gradePickerValues[row]
        }
        //gradeTextField.text = gradePickerValues[row]
        //sub_cat_idself.view.endEditing(true)
    }
    
    
}





