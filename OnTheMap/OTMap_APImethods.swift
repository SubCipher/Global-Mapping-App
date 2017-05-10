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
                completionHandlerForLocations(false, NSError(domain: " URLRequest", code: 1, userInfo: [NSLocalizedDescriptionKey: "error downloading data"]))
                return
                
            } else {
                if let results = response?[OTMap_Tasks.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    for studentInfo in results {
                        let  newRecord = StudentInformation(studentInfo)
                        var objectIDArray = [String]()
                        if StudentInformationArray.count > 0 {
                            
                            //create array of objectIDs to check for dupes, so we only add new IDs found during download
                            for existingID in StudentInformationArray {
                                objectIDArray.append(existingID.objectId)
                            }
                            if objectIDArray.contains(newRecord.objectId) {
                            }  else {
                                self.appendToStudentLocationArray(newRecord)
                            }
                        } else {
                            self.appendToStudentLocationArray(newRecord)
                        }
                    }
                    completionHandlerForLocations(true,nil)
                    // self.studentLocations = results as [String : AnyObject]?
                } else {
                    completionHandlerForLocations(false,NSError(domain: "JSONResults", code: 1, userInfo: [NSLocalizedDescriptionKey:" could not get JSON data results"]))
                }
            }
        }
    }
    
    func appendToStudentLocationArray(_ addRecord: StudentInformation){
        StudentInformationArray.append(addRecord)
    }
    
    func postNewLocation(_ mediaURL:String,_ coordinate: CLLocationCoordinate2D, _ address:String, completionHandlerForPostNewLocation: @escaping (_ success: Bool,_ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"12345678\", \"firstName\": \"K\", \"lastName\": \"Picart00\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
