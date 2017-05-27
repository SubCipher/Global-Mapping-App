//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by knax on 5/7/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//On the map data model

class StudentDataSource {
    var UniqueKey = String()
   
    static let sharedInstance = StudentDataSource()
    

    var StudentData = [StudentInformation]()
    var objectIDArray = [String]()
    
    var firstName:String? = nil
    var lastName:String? = nil
    
    struct StudentInformation {
        
        init(_ dictionary: [String:AnyObject]) {
            firstName = (dictionary["firstName"] as? String) ?? ""
            lastName = (dictionary["lastName"] as? String) ?? ""
            mediaURL = (dictionary["mediaURL"] as? String) ?? ""
            
            mapString = (dictionary["mapString"] as? String) ?? ""
            
            latitude = (dictionary["latitude"] as? Double) ?? 00.0
            longitude = (dictionary["longitude"] as? Double) ?? 00.0
            
            uniqueKey = (dictionary["uniqueKey"] as? Int) ?? 0
            objectId = (dictionary["objectId"] as? String) ?? ""
            
            createdAt = (dictionary["createdAt"] as? String) ?? ""
            updatedAt = (dictionary["updatedAt"] as? String) ?? ""
        }
        var latitude: Double
        var mapString: String
        let createdAt: String!
        let uniqueKey: Int!
        let objectId: String!
        
        let updatedAt: String!
        var firstName: String
        var longitude: Double
        var mediaURL: String
        var lastName: String
    }
    
    struct postUserInfo {
        
        init(_ postInfo: [String:AnyObject])  {
            firstName = (postInfo["firstName"] as? String) ?? ""
            lastName = (postInfo["lastName"] as? String) ?? ""
            mediaURL = (postInfo["mediaURL"] as? String) ?? ""
            
            mapString = (postInfo["mapString"] as? String) ?? ""
            uniqueKey = (postInfo["uniqueKey"] as? String) ?? " "
            latitude = (postInfo["latitude"] as? Double) ?? 00.0
            longitude = (postInfo["longitude"] as? Double) ?? 00.0
            
        }
        
        var firstName: String
        var lastName: String
        var mapString: String
        var uniqueKey: String
        var mediaURL: String
        var latitude: Double
        var longitude: Double
        
    }
    
    
}
