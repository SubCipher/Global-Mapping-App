//
//  OTMap_APImethods.swift
//  OnTheMap
//
//  Created by knax on 4/24/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

extension OTMap_Tasks {
    
    
    func udacityAuthLogin(_ emailAccountText:String, _ userPwdText:String,
                          completionHandlerForSession: @escaping ( _ success: Bool, _ errorString: NSError?) -> Void) {
        
        udacityPostMethod(emailAccountText,userPwdText) { (result, errorString) in
            
            if result != nil {
            completionHandlerForSession(true, errorString)
            } else {
                
            completionHandlerForSession(false,errorString  )
            }
        }
    }
    
    func udacityPostMethod(_ username:String, _ pwd: String,
                           _ completionHandlerForLogin: @escaping ( _ result: AnyObject?, _ error: NSError?) -> Void)  {
        
        /*1. specify the parameters */
        
        let mutableMethod: String = Methods.SessionURL
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(pwd)\"}}"
        
        /*2. make the request */
        
        let _ = taskForPOSTMethod( mutableMethod, jsonBody: jsonBody) { (results, error) in
            
            /*3. send values to competion handler */
            if let error = error {
                completionHandlerForLogin(nil, error)
            } else {
                if let results = results?[OTMap_Tasks.JSONResponseKeys.SessionID] as? [String:AnyObject] {
                    
                    completionHandlerForLogin(results as AnyObject?,nil)
                } else {
                    completionHandlerForLogin(nil, NSError(domain: "line near 54 APIMethods user login attemp", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not login to Udacity account0"]))
                }
                
            }
            
        }
        
    }
    
    func loadStudentLocations(completionHandlerForLocations: @escaping (_ success: Bool,_ errorString: NSError?) -> Void) {
        
       let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        //the fully formed network request
        let request = NSMutableURLRequest(url: URL(string:urlString)!)
        
        request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //active call to server
        let _ = taskForGET(request as URLRequest) { ( response, error ) in
            
                if error != nil {
                    completionHandlerForLocations(false, NSError(domain: " URLRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "error downloading data"]))
                return
                    
            } else {
                if let results = response?[OTMap_Tasks.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    for studentInfo in results {
                       let  newRecord = StudentInformation(studentInfo)
                        StudentInformationArray.append(newRecord)
                    }
  
                    completionHandlerForLocations(true,nil)
                   // self.studentLocations = results as [String : AnyObject]?
                } else {
                    completionHandlerForLocations(false,NSError(domain: "JSONResults", code: 1, userInfo: [NSLocalizedDescriptionKey:" could not get JSON data results"]))
                }
                
            }

        }
        
    }
    
    
    //    private func OTMapURLFromParameters(_ parameters:[String:AnyObject], withPathExtension: String? = nil) -> URL {
    //        var components = URLComponents()
    //
    //        components.scheme = OTMap_Tasks.Constants.ApiScheme
    //        components.host = OTMap_Tasks.Constants.ApiHost
    //        components.path = OTMap_Tasks.Constants.ApiPath + (withPathExtension ?? "")
    //        components.queryItems = [URLQueryItem]()
    //
    //        for (key,value) in parameters {
    //            let queryItem = URLQueryItem(name: key, value: "\(value)")
    //            components.queryItems!.append(queryItem)
    //        }
    //        print("")
    //        print("")
    //        print("components.url!",components.url!)
    //        print("")
    //        print("")
    //        return components.url!
    //    }
    
}
