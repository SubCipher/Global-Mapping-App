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
    //MARK: - Login Method
    func udacityPostForLogin(_ username:String, _ pwd: String,
                             _ completionHandlerForLogin: @escaping ( _ success:Bool , _ error: NSError?) -> Void)  {
        
        let methodAsString = Constants.AuthorizationURL
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(pwd)\"}}"
        
        let request = formatRequest(methodAsString, jsonBody)
       
        let _ = taskForUdacityLoginMethod(request) { (results, error) in
            if error != nil {
                
                completionHandlerForLogin(false, NSError(domain: "Bad login attemp", code: 0, userInfo: [NSLocalizedDescriptionKey: error?.localizedDescription ?? "failed to get error code"]))
                
            } else {
                if let session = results?[OTMap_Tasks.JSONResponseKeys.Account] as? [String:AnyObject] {
                    let uniqueKey = session["key"] as! String
               
                    completionHandlerForLogin(true,nil)
                    
                    //fetch username
                    self.fetchUsernameMethod(uniqueKey) { (success, errorString) in
                        
                        if error != nil {
                            completionHandlerForLogin(success, errorString)
                           
                        }
                        else {
                            completionHandlerForLogin(success, errorString)
                        }
                   
                    }
                }
            }
        }
    }

    //MARK: - Fetch Username Method
    func fetchUsernameMethod(_ uniqueKey: String, _ completionHandlerForUsername: @escaping (_ success: Bool, _ error: NSError?) ->Void) {
        
        let request = URLRequest(url: URL(string: OTMap_Tasks.Constants.UserApi + uniqueKey)!)
        
        let _ = taskForFetchingUserName(request as URLRequest) { ( response, error) in
            if error != nil {
                completionHandlerForUsername(false, error)
                //return
            } else {
               
                if let results = response?[OTMap_Tasks.JSONResponseKeys.User] as? [String:AnyObject]{
                  
                    StudentDataSource.sharedInstance.firstName = results["first_name"] as? String
                    StudentDataSource.sharedInstance.lastName = results["last_name"] as? String
                    
                    completionHandlerForUsername(true,nil)
                    
                } 
            }
        }
    }
   
    
    //MARK: - Get Locations Method
    
    func loadStudentLocations(completionHandlerForLocations: @escaping (_ success: Bool,_ errorString: NSError?) -> Void) {
        
        
        var request = URLRequest(url: URL(string:OTMap_Tasks.Constants.PostURL)!)
        
        request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //active call to server
        
        let _ = taskForLoadingStudentLocations(request as URLRequest) { ( response, error ) in
            
            if error != nil {
                completionHandlerForLocations(false, NSError(domain: " URLRequest", code: 1, userInfo: [NSLocalizedDescriptionKey: "error downloading data"]))
                //return
                
            } else {
                if let results = response?[OTMap_Tasks.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    for studentInfo in results {
                        
                        let newRecord = StudentDataSource.StudentInformation(studentInfo)
                        
                        if !StudentDataSource.sharedInstance.objectIDArray.contains(newRecord.objectId){
                            self.addToStudentLocationArray(newRecord)
                            StudentDataSource.sharedInstance.objectIDArray.append(newRecord.objectId)
                        }
                    }
                    completionHandlerForLocations(true,nil)
                    
                }
                else {
                    completionHandlerForLocations(false,NSError(domain: "JSONResults", code: 1, userInfo: [NSLocalizedDescriptionKey: "could not get JSON data"]))
                }
            }
        }
    }
    
    //MARK: - Post New User Location Method
    
    func postNewLocation(_ postLocation: StudentDataSource.postUserInfo, completionHandlerForPostNewLocation: @escaping (_ success: Bool,_ error: NSError?) -> Void) {
        
        let methodAsString = OTMap_Tasks.Constants.PostURL
        
        let jsonBody = "{\"uniqueKey\": \"\(postLocation.uniqueKey)\", \"firstName\": \"\(postLocation.firstName) \", \"lastName\": \"\(postLocation.lastName)\",\"mapString\": \"\(postLocation.mapString)\", \"mediaURL\": \"\(postLocation.mediaURL)\",\"latitude\": \(postLocation.latitude), \"longitude\": \(postLocation.longitude)}"

        let request = formatRequest(methodAsString, jsonBody)
        
        let _ = taskForNewLocationPostMethod(request) {success, error in
            if error != nil {
                
                completionHandlerForPostNewLocation(false, error)
                
            } else {
            
                completionHandlerForPostNewLocation(true, nil)
            }
        }
    }
    
    //MARK: - Helper Method to add records to array
    func addToStudentLocationArray(_ addRecord: StudentDataSource.StudentInformation){
        
        if StudentDataSource.sharedInstance.StudentData.count < locationsToRetrieve {
            StudentDataSource.sharedInstance.StudentData.append(addRecord)
        } else {
            StudentDataSource.sharedInstance.StudentData.insert(addRecord, at: 0)
        }
    }
    
    //MARK: - Helper Method For formatting POST URLRequest
    func formatRequest(_ mutableString:String, _ jsonBody: String) -> URLRequest{
        
        var request = URLRequest(url: URL(string:mutableString)!)
        request.httpMethod = "POST"
        
        request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        return request
        
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
  
