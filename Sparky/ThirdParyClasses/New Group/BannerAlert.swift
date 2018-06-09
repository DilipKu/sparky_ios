//
//  BannerAlert.swift
//  PowerCoin
//
//  Created by VISHAL SETH on 16/02/18.
//  Copyright © 2018 VISHAL SETH. All rights reserved.
//

import Foundation
import UIKit

struct BannerColors
{
//    static let red = UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000)
//    static let green = UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000)
//    static let yellow = UIColor(red:255.0/255.0, green:204.0/255.0, blue:51.0/255.0, alpha:1.000)
//    static let blue = UIColor(red:31.0/255.0, green:136.0/255.0, blue:255.0/255.0, alpha:1.000)
    static let red = UIColor(red:96.0/255.0, green:150.00/255.0, blue:202.0/255.0, alpha:1.000)
    static let green = UIColor(red:96.00/255.0, green:150.0/255.0, blue:202/255.0, alpha:1.000)
    static let yellow = UIColor(red:96.0/255.0, green:150.0/255.0, blue:202.0/255.0, alpha:1.000)
    static let blue = UIColor(red:96/255.0, green:150.0/255.0, blue:202.0/255.0, alpha:1.000)
}


func showSuccessBanner(titleString:String,subtitleString:String,inView:Bool)
    {
        //let color = currentColor()
        let color = BannerColors.green
        let image = UIImage.init(named: "Test")
        let title = titleString
        let subtitle = subtitleString
        let banner = Banner(title: title, subtitle: subtitle, image: image, backgroundColor: color)
        banner.springiness = currentSpringiness()
        banner.position = currentPosition()
        banner.didTapBlock = {
            print("Banner was tapped on \(Date())!")
        }
        banner.show(duration: 3.0)
//        if (inView)
//        {
//            banner.show(duration: 3.0)
//        }
//        else
//        {
//            banner.show(inView, duration: 3.0)
//        }
    }

func showWarningBanner(titleString:String,subtitleString:String,inView:Bool)
{
    //let color = currentColor()
    let color = BannerColors.yellow
    let image = UIImage.init(named: "Test")
    let title = titleString
    let subtitle = subtitleString
    let banner = Banner(title: title, subtitle: subtitle, image: image, backgroundColor: color)
    banner.springiness = currentSpringiness()
    banner.position = currentPosition()
    banner.didTapBlock = {
        print("Banner was tapped on \(Date())!")
    }
    banner.show(duration: 3.0)
    //        if (inView)
    //        {
    //            banner.show(duration: 3.0)
    //        }
    //        else
    //        {
    //            banner.show(inView, duration: 3.0)
    //        }
}
func showErrorBanner(titleString:String,subtitleString:String,inView:Bool)
{
    //let color = currentColor()
    let color = BannerColors.red
    let image = UIImage.init(named: "Test")
    let title = titleString
    let subtitle = subtitleString
    let banner = Banner(title: title, subtitle: subtitle, image: image, backgroundColor: color)
    banner.springiness = currentSpringiness()
    banner.position = currentPosition()
    banner.didTapBlock = {
        print("Banner was tapped on \(Date())!")
    }
    banner.show(duration: 3.0)
    //        if (inView)
    //        {
    //            banner.show(duration: 3.0)
    //        }
    //        else
    //        {
    //            banner.show(inView, duration: 3.0)
    //        }
}
    
    func currentPosition() -> BannerPosition
    {
        return .top
        /*
        switch positionSegmentedControl.selectedSegmentIndex
        {
        case 0: return .top
        default: return .bottom
        }
        */
    }
    
    func currentSpringiness() -> BannerSpringiness
    {
        return .heavy
        /*
        switch springinessSegmentedControl.selectedSegmentIndex {
        case 0: return .none
        case 1: return .slight
        default: return .heavy
        }
        */
    }

    /*
    func currentColor() -> UIColor {
        
        switch colorSegmentedControl.selectedSegmentIndex {
        case 0: return BannerColors.red
        case 1: return BannerColors.green
        case 2: return BannerColors.yellow
        default: return BannerColors.blue
        }
    }
     */
    


extension String {
    var validated: String? {
        if self.isEmpty { return nil }
        return self
    }
}
