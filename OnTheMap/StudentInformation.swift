//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by knax on 5/7/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import Foundation
import UIKit

//On the map data model

var StudentInformationArray = [StudentInformation]()



//http://www.thomashanning.com/sorting-arrays-swift/





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
    
    let latitude: Double
    let mapString: String
    let createdAt: String
    let uniqueKey: Int
    let objectId: String
    
    let updatedAt: String
    let firstName: String
    let longitude: Double
    let mediaURL: String
    let lastName: String
    
    
    
}
