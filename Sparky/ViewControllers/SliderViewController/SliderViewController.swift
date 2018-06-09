//
//  SliderViewController.swift
//  FAR
//
//  Created by VISHAL-SETH on 12/14/17.
//  Copyright © 2017 Infoicon. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell
{
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imgSlider: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnImageTitle: UIButton!
    @IBOutlet weak var btnNext: UIButton!
}

class SliderViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK://------PROPERIETY DELCARATION-------
    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    let arrSlider=["1.png","2.png","3.png","4.png"];
    //MARK://------LIFE CYCLE METHOD-------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialSetup()
        
        guard  let result:String=UserDefaults.standard.value(forKey: "IntroViewd") as? String
        
        else
        {
            return
        }
        
        if result=="Viewed"
        {
            self.jumpToDashboard()
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK://------CUSTOM METHODS-------
    func initialSetup()
    {
        let cellWidth : CGFloat = self.view.frame.size.width
        let cellheight : CGFloat = self.view.frame.size.height
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
    
    @IBAction func btnGotoDashbaordAction(_ sender: Any)
    {
        jumpToDashboard()
    }
    
    @IBAction func btnNextAction(_ sender: Any)
    {
        if self.btnNext.titleLabel?.text=="GOT IT"
        {
            self.jumpToDashboard()
        }
        else
        {
            let collectionBounds = self.collectionSlider.bounds
            let contentOffset = CGFloat(floor(self.collectionSlider.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat)
    {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionSlider.contentOffset.y ,width : self.collectionSlider.frame.width,height : self.collectionSlider.frame.height)
        self.collectionSlider.scrollRectToVisible(frame, animated: true)
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionSlider.contentOffset
        visibleRect.size = collectionSlider.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionSlider.indexPathForItem(at: visiblePoint)!
        print(visibleIndexPath.item)
        pageControl.currentPage=visibleIndexPath.item+1
        if pageControl.currentPage>0
        {
            self.btnSkip.isHidden=true;
        }
        else
        {
            self.btnSkip.isHidden=false
        }
        
        if pageControl.currentPage==3
        {
            self.btnNext.setTitle("GOT IT", for: .normal)
        }
        else
        {
            self.btnNext.setTitle("NEXT", for: .normal)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        var visibleRect = CGRect()
        visibleRect.origin = collectionSlider.contentOffset
        visibleRect.size = collectionSlider.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionSlider.indexPathForItem(at: visiblePoint)!
        print(visibleIndexPath.item)
        pageControl.currentPage=visibleIndexPath.item
        
        if pageControl.currentPage>0
        {
            self.btnSkip.isHidden=true;
        }
        else
        {
            self.btnSkip.isHidden=false
        }
        
        if pageControl.currentPage==3
        {
            self.btnNext.setTitle("GOT IT", for: .normal)
        }
        else
        {
            self.btnNext.setTitle("NEXT", for: .normal)
        }
    }
    
    func jumpToDashboard()
    {
        UserDefaults.standard.set("Viewed", forKey: "IntroViewd")
        UserDefaults.standard.synchronize()
        let vc=self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        let nav=UINavigationController.init(rootViewController: vc)
        
        nav.navigationBar.barTintColor = UIColor.init(red: 80/255.0, green: 136/255.0, blue: 189/255.0, alpha: 1.0)
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        nav.navigationBar.tintColor=UIColor.white
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = nav
        
        UserDefaults.standard.set("YES", forKey: "IntroViewed")
        UserDefaults.standard.synchronize()
    }
 

}

extension SliderViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:SliderCell=collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        cell.imgSlider.image=UIImage.init(named: arrSlider[indexPath.item])
        return cell
    }
}
