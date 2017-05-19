//
//  OTMap_APImethods.swift
//  OnTheMap
//
//  Created by knax on 4/24/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import CoreLocation

extension OTMap_Tasks {
    
    
    func udacityPostForLogin(_ username:String, _ pwd: String,
                             _ completionHandlerForLogin: @escaping ( _ success:Bool , _ error: NSError?) -> Void)  {
        
        /*1. specify the parameters */
        
        let mutableMethod: String = Constants.AuthorizationURL
        
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(pwd)\"}}"
        
        /*2. make the request */
        
        let _ = taskForUdacityPOSTMethod( mutableMethod, jsonBody) { (results, error) in
            
            //*3. send values to competion handler */
            if let error = error {
                completionHandlerForLogin(false, error)
            } else {
                if let session = results?[OTMap_Tasks.JSONResponseKeys.SessionID] as? [String:AnyObject] {
                    self.sessionID = session
                    completionHandlerForLogin(true,nil)
                } else {
                    completionHandlerForLogin(false, NSError(domain: "Bad login attemp", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not login to Udacity account"]))
                }
            }
        }
    }
    //MARK: - get JSON data from server, ini structs and load each instance into data model (StudentInformationArray)
    
    func loadStudentLocations(completionHandlerForLocations: @escaping (_ success: Bool,_ errorString: NSError?) -> Void) {
        
        let urlString = OTMap_Tasks.Constants.PostURL
        
        //the fully formed network request
        let request = NSMutableURLRequest(url: URL(string:urlString)!)
        
        request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //active call to server
        
        let _ = taskForGET(request as URLRequest) { ( response, error ) in
            
            if error != nil {
                completionHandlerForLocations(false, NSError(domain: " URLRequest", code: 1, userInfo: [NSLocalizedDescriptionKey: "error downloading data"]))
                return
                
            } else {
                if let results = response?[OTMap_Tasks.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    for studentInfo in results {
                        
                        let  newRecord = StudentInformation(studentInfo)
                        
                        if !objectIDArray.contains(newRecord.objectId){
                            self.appendToStudentLocationArray(newRecord)
                            objectIDArray.append(newRecord.objectId)
                        }
                    }
                    completionHandlerForLocations(true,nil)
                } else {
                    
                    completionHandlerForLocations(false,NSError(domain: "JSONResults", code: 1, userInfo: [NSLocalizedDescriptionKey:" could not get JSON data results"]))
                }
            }
        }
    }
    
    
    //MARK: - append records to array
    func appendToStudentLocationArray(_ addRecord: StudentInformation){
        if StudentInformationArray.count < locationsToRetrieve {
            
            StudentInformationArray.append(addRecord)
        } else {
            StudentInformationArray.insert(addRecord, at: 0)
            
        }
    }
    
    //MARK: - post new location (parse api)
    
    func postNewLocation(_ mediaURL:String,_ coordinate: CLLocationCoordinate2D, _ address:String, completionHandlerForPostNewLocation: @escaping (_ success: Bool,_ error: NSError?) -> Void) {
        
        let  mutableMethod = OTMap_Tasks.Constants.PostURL
        
        let jsonBody = "{\"uniqueKey\": \"12345678\", \"firstName\": \"K\", \"lastName\": \"Picart14b\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}"
        
        let _ = taskForParsePOSTMethod(mutableMethod, jsonBody) {success, error in
            
            if error != nil {
                
                completionHandlerForPostNewLocation(false, error)
            } else {
                
                completionHandlerForPostNewLocation(true, nil)
            }
        }
    }
    
    //MARK: - Logout Method
    func udacityLogoutMethod(completionHandlerForLogout: @escaping ( _ success:Bool, _ error: NSError?) ->Void) {
        
        let request = NSMutableURLRequest(url: URL(string: OTMap_Tasks.Constants.AuthorizationURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                completionHandlerForLogout(false,NSError(domain: "SessionLogout", code: 1, userInfo: [NSLocalizedDescriptionKey: "Erorr while loging out"]))
                return
            }
            completionHandlerForLogout(true,nil)
        }
        task.resume()
    }
}
