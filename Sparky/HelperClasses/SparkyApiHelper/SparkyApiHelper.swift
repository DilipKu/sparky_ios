//
//  FarApiClient.swift
//  FAR
//
//  Created by VISHAL-SETH on 12/30/17.
//  Copyright © 2017 Infoicon. All rights reserved.
//

import UIKit
import Alamofire
class SparkyApiHelper: NSObject {
    //MARK:- APi call with parameter only
    class func apiCall(serviceName: String,param: Any?,showLoader: Bool? = nil,
                       completionClosure: @escaping(NSDictionary?,Error?) ->())
    {
        
        if CommonFunction.isInternetAvailable()
        {
            var isShowLoader=true
            if let show = showLoader
            {
                if show == false
                {
                    isShowLoader=false
                }
                else
                {
                    isShowLoader=true
                }
            }
            
            if isShowLoader
            {
                CommonFunction.startLoader(title: "Loading...")
            }
            
            var paramValues:Parameters?
            paramValues = param as? Parameters
            
            print("REQUEST URL :: \(serviceName)")
            print("REQUEST PARAMETERS :: \(String(describing: paramValues))")
            
            
            
            //Header Implementation
            //            let valueArrayNotToCheckAuth = [API_CONSTANT.kLogin,API_CONSTANT.kRegister,API_CONSTANT.kForgotPassword,API_CONSTANT.kCountry]
            let headers: HTTPHeaders = [
            "Content-Type":"application/json"
            ]
            //            if  valueArrayNotToCheckAuth.contains(serviceName){
            //                headers = [
            //                    "Content-Type": "application/json"
            //                ]
            //            }else{
            //
            //                headers = [
            //                    "Content-Type": "application/json",
            //                    "USER": CommonFunction.getUserIdFromUserDefault()
            //                ]
            //            }
            
            
            // Remove above code if you dont want to Header
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
            manager.request(serviceName,method:.post,parameters:paramValues,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
                
                CommonFunction.stopLoader()
                switch response.result
                {
                case .success:
                    
                    if let JSON = response.result.value{
                        
                        debugPrint("Repsonse::\(JSON)");
                        
                        DispatchQueue.main.async
                            {
                                
                                let responseJson=JSON as? NSDictionary
                                completionClosure(responseJson, nil)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    CommonFunction.showAlert(message: error.localizedDescription)
                    //completionClosure(JSON as? NSDictionary, nil)
                }
                
            }
            
        }
        
    }
    
    class func apiCallDownloadPdf(serviceName: String,param: Any?,showLoader: Bool? = nil,
                                 completionClosure: @escaping(URL?,Error?) ->())
    {
        if CommonFunction.isInternetAvailable()
        {
            var isShowLoader=true
            if let show = showLoader
            {
                if show == false
                {
                    isShowLoader=false
                }
                else
                {
                    isShowLoader=true
                }
            }
            
            if isShowLoader
            {
                CommonFunction.startLoader(title: "Loading...")
            }
            
            var paramValues:Parameters?
            paramValues = param as? Parameters
            
            print("REQUEST URL :: \(serviceName)")
            print("REQUEST PARAMETERS :: \(String(describing: paramValues))")
            
            
            
            //Header Implementation
            //            let valueArrayNotToCheckAuth = [API_CONSTANT.kLogin,API_CONSTANT.kRegister,API_CONSTANT.kForgotPassword,API_CONSTANT.kCountry]
            let headers: HTTPHeaders = [
                "Content-Type":"application/json"
            ]
            //            if  valueArrayNotToCheckAuth.contains(serviceName){
            //                headers = [
            //                    "Content-Type": "application/json"
            //                ]
            //            }else{
            //
            //                headers = [
            //                    "Content-Type": "application/json",
            //                    "USER": CommonFunction.getUserIdFromUserDefault()
            //                ]
            //            }
            
            
            // Remove above code if you dont want to Header
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 60
            
           
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                
                let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as    NSURL
                
                let PDF_name : String = "All_User_List.pdf"
                
                let fileURL = documentsURL.appendingPathComponent(PDF_name)
                
                
                return (fileURL!,[.removePreviousFile, .createIntermediateDirectories])
                
            }
            
            
            manager.download(serviceName, to: destination).downloadProgress(closure: { (prog) in
                
                
                
            }).response { response in
                
                CommonFunction.stopLoader()
                if response.error == nil, let filePath = response.destinationURL?.path
                {
                    
                    //Open this filepath in Webview Object
                    
                    let fileURL = URL(fileURLWithPath: filePath)
                    
                    
                    completionClosure(fileURL, nil)
                }
            }
            
        }
    }
    
       //MARK:- Upload Image and video with parameter
 
    class func apiCallWithImageAndVideos(serviceName: String,image:NSArray,video : NSArray,param: Any?,showLoader: Bool? = nil,
                                completionClosure: @escaping(NSDictionary?,Error?) ->())
    {
        if CommonFunction.isInternetAvailable(){
            
            var isShowLoader=true
            if let show = showLoader{
                
                if show == false{
                    isShowLoader=false
                }else{
                    isShowLoader=true
                }
            }
            
            if isShowLoader{
                CommonFunction.startLoader(title: "Loading...")
            }
            
            print("REQUEST URL :: \(serviceName)")
            print("REQUEST PARAMETERS :: \(String(describing: param))")
            
            var paramString:String?
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: param!,
                options: []) {
                
                let theJSONText = String(data: theJSONData,
                                         encoding: .utf8)!
                
                paramString = theJSONText as String
                print("JSON string = \(theJSONText)")
            }
            
            var headers: HTTPHeaders = [:]
            headers = [
                "Content-Type": "application/json"
            ]
            
            let manager = Alamofire.SessionManager.default
         
            manager.upload(multipartFormData: { multipartFormData in
                // import image to request
                for i in 0..<image.count
                {
                   // NSURLQueryItem(name: "front_prd_img", value:front_prd_img),
                   // NSURLQueryItem(name: "side_prd_img", value:side_prd_img),
                   // NSURLQueryItem(name: "back_prd_img", value:back_prd_img)]
                    if i==0
                    {
                        let imageData = UIImageJPEGRepresentation(image[i] as! UIImage, 0.6)
                        multipartFormData.append(imageData!, withName:"front_prd_img", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/jpeg")
                    }
                    else if i==1
                    {
                        let imageData = UIImageJPEGRepresentation(image[i] as! UIImage, 0.6)
                        multipartFormData.append(imageData!, withName:"side_prd_img", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/jpeg")
                    }
                    else if i==2
                    {
                        let imageData = UIImageJPEGRepresentation(image[i] as! UIImage, 0.6)
                        multipartFormData.append(imageData!, withName:"back_prd_img", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/jpeg")
                    }
                    
                }
                multipartFormData.append((paramString?.data(using: String.Encoding.utf8)!)!, withName: "data")
            },to: serviceName,headers: headers, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Image upload:\(response)")
                        if let JSON = response.result.value
                        {
                            //debugPrint("Repsonse::\(JSON)");
                            
                            DispatchQueue.main.async {
                                
                                let responseJson=JSON as? NSDictionary
                                
                                CommonFunction.stopLoader()
                                completionClosure(responseJson, nil)
                            }
                        }
                    }
                case .failure(let encodingError):
                    CommonFunction.stopLoader()
                    CommonFunction.showAlert(message: encodingError.localizedDescription)
                    print("encodingError:\(encodingError)")
                }
            })
        }
        
        
    }
    
    
 
    
       //MARK:- Upload Image with parameter
    
    class func apiCallWithImage(serviceName: String,image:UIImage,imageName:String,param: Any?,showLoader: Bool? = nil,
                                completionClosure: @escaping(NSDictionary?,Error?) ->())
    {
        
        if CommonFunction.isInternetAvailable(){
            
            var isShowLoader=true
            if let show = showLoader{
                
                if show == false{
                    isShowLoader=false
                }else{
                    isShowLoader=true
                }
            }
            
            if isShowLoader{
                CommonFunction.startLoader(title: "Loading...")
            }
            
            print("REQUEST URL :: \(serviceName)")
            print("REQUEST PARAMETERS :: \(String(describing: param))")
            
            var paramString:String?
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: param!,
                options: []) {
                
                let theJSONText = String(data: theJSONData,
                                         encoding: .utf8)!
                
                paramString = theJSONText as String
                print("JSON string = \(theJSONText)")
            }
            
            var headers: HTTPHeaders = [:]
            headers = [
                "Content-Type": "multipart/form-data",
                //"USER": CommonFunction.getUserIdFromUserDefault(),
                //"LANG" : UserDefaults.standard.value(forKey: "language") as! String
            ]
            
            let manager = Alamofire.SessionManager.default
            
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            
            manager.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: imageName,fileName: "file.jpg", mimeType: "image/jpg")
                
                
                
                multipartFormData.append((paramString?.data(using: String.Encoding.utf8)!)!, withName: "data")
                
                
            }, to: serviceName,headers: headers, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        print("Image upload:\(response)")
                        if let JSON = response.result.value{
                            
                            //debugPrint("Repsonse::\(JSON)");
                            
                            DispatchQueue.main.async {
                                
                                let responseJson=JSON as? NSDictionary
                                
                                CommonFunction.stopLoader()
                                completionClosure(responseJson, nil)
                            }
                        }
                    }
                case .failure(let encodingError):
                    CommonFunction.stopLoader()
                    CommonFunction.showAlert(message: encodingError.localizedDescription)
                    print("encodingError:\(encodingError)")
                }
            })
        }
        
    }
}
