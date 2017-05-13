//
//  OTMap_Tasks.swift
//  OnTheMap
//
//  Created by knax on 4/25/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import Foundation

class OTMap_Tasks: NSObject {
    
   var studentLocations: [String:AnyObject]? = nil
    var sessionID = [String:AnyObject]()
    
    var session = URLSession.shared
        
    override init() {
    super.init()
    }

    //MARK: - UdacityPostMethod
    func taskForUdacityPOSTMethod(_ method: String,_ jsonBody: String, completionHandlerForUdacityPOST: @escaping (_ result:
        AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: method)!)
        
        request.httpMethod = "Post"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
     
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUdacityPOST(nil, NSError(domain: "TaskForPost", code: 1, userInfo: userInfo))
                 print("return error = ",error)
            }
            
            guard (error == nil) else {
                sendError("there was an error with your request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
               
                //parse account errors: valid account vs. bad authentication
                let responseValue = (response as? HTTPURLResponse)?.statusCode
                if let responseValue = responseValue {
                    if responseValue == 400 {
                        sendError("invailid user name or password")
                    } else if responseValue == 403 {
                        sendError("bad user name or password")
                    } else {
                        sendError("connection error")
                    }
                }
                
                return
            }
            
            guard let data = data else {
                sendError("no data was returned by the request")
                return
            }
            
            //if let data = data {
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            self.convertDataWithCompletionHandler(newData,completionHandlerForConvertData: completionHandlerForUdacityPOST)
        }
        
        task.resume()
        return task
        }
    
    //MARK:- Parse Post Method
    func taskForParsePOSTMethod(_ method: String,_ jsonBody: String, completionHandlerForParsePOST: @escaping (_ result:
        Bool, _ error: NSError?) -> Void) -> URLSessionDataTask {
       
        
        var  request = URLRequest(url: URL(string:method)!)
            request.httpMethod = "POST"
            request.addValue(OTMap_Tasks.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(OTMap_Tasks.Constants.RESTapi, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForParsePOST(false, NSError(domain: "TaskForPost", code: 1, userInfo: userInfo))
                print("return error = ",error)
            }
            
            guard (error == nil) else {
                sendError("there was an error with your request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                //parse account errors: valid account vs. bad authentication
                let responseValue = (response as? HTTPURLResponse)?.statusCode
                if let responseValue = responseValue {
                   print("parse post response",responseValue)
                }
                
                return
            }
            
            completionHandlerForParsePOST(true, nil)
            
       }
        
        task.resume()
        return task
    }

    
    
    
    
    
    
    
    
    
    //Mark: Udacity Get Method
    func taskForGET( _ request :URLRequest, completionHandlerForGET: @escaping (_ result:AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError( _ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "task for GET handler ", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("there was an error with your request: Line 88 TaskSwift")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >=  200 && statusCode <= 299 else {
                sendError("82: Your request returned a status code other than 2xx")
                return
            }
            guard let data = data else {
                sendError("no data was returned by the request")
                return
            }
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            }
        task.resume()
        
        return task
            
        }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject

        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "could not parse the JSON data as JSON: '\(data)'"]
            completionHandlerForConvertData(true as AnyObject?,NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult as AnyObject?,nil)
    }
    
    
    func substituteKeyInMethod(_ method: String,key:String, value:String) -> String? {
        if method.range(of: "\(key)") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    
    class func sharedInstance() -> OTMap_Tasks {
        struct Singleton {
            static var sharedInstance =  OTMap_Tasks()
        }
        return Singleton.sharedInstance
    }
}
