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
                    completionHandlerForLogin(false, NSError(domain: "line near 54 APIMethods user login attemp", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not login to Udacity account0"]))
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
    
    //MARK: - apend records to arry
    func appendToStudentLocationArray(_ addRecord: StudentInformation){
        StudentInformationArray.append(addRecord)
    }
    
    //MARK: - post new location (parse api)
    func postNewLocation(_ mediaURL:String,_ coordinate: CLLocationCoordinate2D, _ address:String, completionHandlerForPostNewLocation: @escaping (_ success: Bool,_ error: NSError?) -> Void) {
        
        let  mutableMethod = "https://parse.udacity.om/parse/classes/StudentLocation"
        
        let jsonBody = "{\"uniqueKey\": \"12345678\", \"firstName\": \"K\", \"lastName\": \"Picart04\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}"
        
        let _ = taskForParsePOSTMethod(mutableMethod, jsonBody) { response, error in
            
            if let error = error {
                
                completionHandlerForPostNewLocation(false, error)
            } else {
                completionHandlerForPostNewLocation(true, nil)
            }
        
        }
    }
}
