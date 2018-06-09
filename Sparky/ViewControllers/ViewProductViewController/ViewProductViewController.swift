//
//  ViewProductViewController.swift
//  Sparky
//
//  Created by VISHAL SETH on 2/11/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import UIKit
import SDWebImage
class ViewProductViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var collectionSlider: UICollectionView!
    var arrProcuts=[ProductDetailModel]()
    var cat_id:String=""
    var prd_id:String=""
    var prd_title:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=self.prd_title
        initialSetup()
        self.getProducts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup()
    {
        let cellWidth : CGFloat = self.view.frame.size.width-1
        let cellheight : CGFloat = self.view.frame.size.height-130
        let cellSize = CGSize(width: cellWidth , height:cellheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 2)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionSlider.setCollectionViewLayout(layout, animated: true)
        collectionSlider.reloadData()
    }
    
    func getProducts()
    {
        let params=[String:String]()
        let queryItems = [NSURLQueryItem(name: "cat_id", value: self.cat_id)]
        let urlComps = NSURLComponents(string: API_CONSTANT.kViewProduct)!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let URL = urlComps.url!
        SparkyApiHelper.apiCall(serviceName: URL.absoluteString, param: params)
        { (response, error) in
            let status=response!["status"]as! Bool
            if status
            {
                let arraymenu = response?["Product Details"] as! NSArray
                for dic in arraymenu
                {
                    let tempDic = dic as! NSDictionary
                    let id = tempDic["sub_cat_id"]as! String
                    let catid = tempDic["cat_id"]as! String
                    if catid==self.cat_id && id==self.prd_id
                    {
                        self.arrProcuts.append(ProductDetailModel(dict: tempDic));
                    }
                    
                }
                self.collectionSlider.reloadData()
                
                
            }
            else
            {
                let message=response!["message"]as! String
                showErrorBanner(titleString: APP_NAME, subtitleString: message, inView: true)
            }
            self.collectionSlider.reloadData()
        }
    }

}

extension ViewProductViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProcuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:SliderCell=collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        cell.imgSlider.image=UIImage.init(named: arrProcuts[indexPath.item].front_image_path)
        
        
        if (arrProcuts[indexPath.item].front_image_path=="")
        {
            
        }
        else{
            let imageUrl:URL=URL.init(string:arrProcuts[indexPath.item].front_image_path)!
            
            cell.imgSlider.sd_showActivityIndicatorView()
            cell.imgSlider.sd_setImage(with: imageUrl, placeholderImage: UIImage.init(named: ""), options: SDWebImageOptions.cacheMemoryOnly) { (image, error, cache, url) in
                
            }
        }
        
        cell.btnImageTitle.setTitle(arrProcuts[indexPath.row].item_desc, for: .normal)
        if indexPath.row==arrProcuts.count-1
        {
            cell.btnNext.setTitle("<<END", for: .normal)
        }
        else
        {
            cell.btnNext.setTitle("<<SLIDE>>", for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController")as! ProductDetailsViewController
        vc.arrProcuts=self.arrProcuts
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class ProductDetailModel:NSObject
{
    var id:String = ""
    var cat_id:String = ""
    var sub_cat_id:String=""
    var front_image_path:String=""
    var side_image_path:String=""
    var back_image_path:String = ""
    var item_code:String=""
    var item_desc:String = ""
    var status:String=""
    var rate:String = ""
    var quantity:String = ""
    var prod_size:String = ""
 
    init(dict:NSDictionary)
    {
        id=dict["id"]as! String
        cat_id=dict["cat_id"]as! String
        sub_cat_id=dict["sub_cat_id"]as! String
        front_image_path=dict["front_image_path"]as! String
        side_image_path=dict["side_img_path"]as! String
        back_image_path=dict["back_image_path"]as! String
        item_code=dict["item_code"]as! String
        item_desc=dict["item_description"]as! String
        status=dict["status"]as! String
        rate=dict["rate"]as! String
        quantity=dict["quantity"]as! String
        prod_size=dict["prd_size"]as! String
    }
}

