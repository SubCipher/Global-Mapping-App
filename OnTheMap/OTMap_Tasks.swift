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
    
    let locationsToRetrieve = 100
    
    //MARK: - Udacity Login Method
    
    func taskForUdacityLoginMethod(_ request: URLRequest,
                                   completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
  
            func sendError(_ error: String) {
    
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForLogin(nil, NSError(domain: "TaskForPost", code: 1, userInfo: userInfo))
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
                        
                        sendError("invalid user name or password")
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
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
                       
            self.convertDataWithCompletionHandler(newData,completionHandlerForConvertData: completionHandlerForLogin)
        }
        task.resume()
        return task
    }
    
     
    
    //MARK: - Fetch username
    func taskForFetchingUserName(_ method: URLRequest,
                                 completionHandlerForUsername: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: method) { (data, response, error) in
            
            func sendError( _ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUsername(nil, NSError(domain: "task for fetchUsername", code: 5, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("there was an error with your request")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >=  200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx")
                return
            }
            guard let data = data else {
                sendError("no data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            

            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForUsername)
        }
        task.resume()
        return task
    }
    
    //MARK:- Task For Parse Post Method
    func taskForNewLocationPostMethod(_ processedURL: URLRequest,
                                      completionHandlerForParsePOST: @escaping (_ result: Bool, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        let task = session.dataTask(with: processedURL as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForParsePOST(false, NSError(domain: "TaskForPost", code: 1, userInfo: userInfo))
                
            }
            
            guard (error == nil) else {
                sendError("there was an error with your request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                //parse account errors: valid account vs. bad authentication
                let responseValue = (response as? HTTPURLResponse)?.statusCode
                if let responseValue = responseValue { print("parse post response",responseValue) }
                return
            }
            completionHandlerForParsePOST(true, nil)
        }
        
        task.resume()
        return task
    }
    
    //Mark: - Task For Udacity Get Method
    func taskForLoadingStudentLocations( _ request :URLRequest,
                                         completionHandlerForGET: @escaping (_ result:AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError( _ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "task for loading student data ", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("there was an error with your request")
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
    
    //MARK: - Convert from json
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "could not parse the JSON data: '\(data)'"]
            completionHandlerForConvertData(true as AnyObject?,NSError(domain: "convertDataWithCompletionHandler", code: 2, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult as AnyObject?,nil)
    }
    
    
    class func sharedInstance() -> OTMap_Tasks {
        struct Singleton {
            static var sharedInstance =  OTMap_Tasks()
        }
        
        return Singleton.sharedInstance
    }
    //MARK: - GCD
    func performUpdatesOnMainQueue(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }

 
}
