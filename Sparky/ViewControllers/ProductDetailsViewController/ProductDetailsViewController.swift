//
//  ProductDetailsViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/11/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblArticleNo: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblDislikes: UILabel!
    
    @IBOutlet weak var viewDeleteProduct: UIView!
    var arrProcuts=[ProductDetailModel]()
    var userType:String = ""
    var currentIndex:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Product Detail"
        let dict=UserDefaults.standard.value(forKey: "userData")as! NSDictionary
        userType=dict["role"]as! String
        
        self.initialSetup()
        getDetials()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDetials()
    {
          //http://sparkyapp.softcoreindia.com/view_products.php?item_code=567
        
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "item_code", value:arrProcuts[0].item_code)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kViewProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params) { (response, error) in
            print(response ?? "")
            let status=response!["status"]as! Bool
            if status
            {
                let arraymenu = response?["Product Details"] as! NSArray
                self.arrProcuts.removeAll()
                for dic in arraymenu
                {
                    let tempDic = dic as! NSDictionary
                    self.arrProcuts.append(ProductDetailModel(dict: tempDic));
                }
                self.collectionSlider.reloadData()
                self.lblArticleNo.text=self.arrProcuts[0].item_code
                self.lblDescription.text=self.arrProcuts[0].item_desc
                self.lblRate.text=self.arrProcuts[0].rate
                
                let dict=arraymenu[0]as! NSDictionary
                if let like_value = dict["like_status"] as? String
                {
                    self.lblLikes.text=like_value
                }
                if let dislike_value = dict["dislike_status"] as? String
                {
                    self.lblDislikes.text=dislike_value
                }
                
                
            }
            else
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
        }
    }
    
    func initialSetup()
    {
        let cellWidth : CGFloat = self.view.frame.size.width-1
        let cellheight : CGFloat = self.collectionSlider.frame.size.height
        let cellSize = CGSize(width: cellWidth , height:cellheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 2)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionSlider.setCollectionViewLayout(layout, animated: true)
        collectionSlider.reloadData()
        collectionSlider.isPagingEnabled=true
        
        lblArticleNo.text=arrProcuts[0].item_code
        lblDescription.text=arrProcuts[0].item_desc
        lblRate.text=arrProcuts[0].rate
        
        if userType=="1"
        {
            viewDeleteProduct.isHidden=false
        }
        else
        {
            viewDeleteProduct.isHidden=true
        }
    }
    
    
    @IBAction func btnLikesAction(_ sender: Any)
    {
        
        let userid=CommonFunction.getUserIdFromUserDefault()
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "user_id", value:userid),
                          NSURLQueryItem(name: "item_code", value:arrProcuts[0].item_code),
                          NSURLQueryItem(name: "rating_status", value:"1")]
        let urlComps = NSURLComponents(string: API_CONSTANT.kLikeDisLikeProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params) { (response, error) in
            
            let status=response!["status"]as! Bool
            if status
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
            else
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
        }
    }
    
    @IBAction func btnDislikesAction(_ sender: Any)
    {
        let userid=CommonFunction.getUserIdFromUserDefault()
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "user_id", value:userid),
                          NSURLQueryItem(name: "item_code", value:arrProcuts[0].item_code),
                          NSURLQueryItem(name: "rating_status", value:"0")]
        let urlComps = NSURLComponents(string: API_CONSTANT.kLikeDisLikeProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params) { (response, error) in
            
            let status=response!["status"]as! Bool
            if status
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
            else
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
        }
        
    }
    
    
    @IBAction func btnDeleteProductAction(_ sender: Any)
    {
        
        
        self.showLogoutPopup()
        
    }
    
    func showLogoutPopup()
    {
        let alertController = UIAlertController(title: "Sparky", message: "Are you sure to delete this product ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.deleteProduct()
        })
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteProduct()
    {
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "prd_id", value:arrProcuts[currentIndex].id)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kDeleteProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params) { (response, error) in
            
            let status=response!["status"]as! Bool
            if status
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
                self.self.arrProcuts.remove(at: self.currentIndex)
                self.collectionSlider.reloadData()
                self.currentIndex=0
            }
            else
            {
                let message=response!["message"]as! String
                showSuccessBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
        }
    }
    
    
}

extension ProductDetailsViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProcuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:SliderCell=collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        cell.imgSlider.image=UIImage.init(named: arrProcuts[indexPath.item].front_image_path)
        let imageUrl:URL=URL.init(string:arrProcuts[indexPath.row].front_image_path)!
        cell.imgSlider.sd_showActivityIndicatorView()
        cell.imgSlider.sd_setImage(with: imageUrl, placeholderImage: UIImage.init(named: ""), options: SDWebImageOptions.cacheMemoryOnly) { (image, error, cache, url) in
            
        }
        cell.pageControl.numberOfPages=arrProcuts.count
        cell.pageControl.currentPage=indexPath.item
        self.currentIndex=indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:SliderCell=collectionView.cellForItem(at: indexPath) as! SliderCell
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imgSlider
        }
        
        present(ImageViewerController(configuration: configuration), animated: true)
    }
}

