//
//  OTMap_Constants.swift
//  OnTheMap
//
//  Created by knax on 4/24/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

extension OTMap_Tasks {
    
    struct Constants {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTapi = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //MARK: Base URLS
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse"
        static let AuthorizationURL = "https://www.udacity.com/api/session"
    
    }
    
    struct URLKeys {
        static let SessionID = "id"
    }
    
    //MARK: methods
    struct Methods {
        static let SessionURL = "/api/session"
        static let StudentLocationURL = "/classes/StudentLocation"
    }
    //MARK: Parameter Keys
    struct ParameterKeys {

    static let SessionID = "session_id"
    static let Query = "query"
    }
    
    //MARK: JSON Body Keys
    
    struct JSONBodyKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let CreatedAt = "createdAt"
        static let UniqueKey = "uniqueKey"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let Long = "longitude"
        static let Lat = "latitude"
        static let MediaURL = "mediaURL"
       
    }
    struct JSONResponseKeys {
        //MARK: General
        static let Status = "status"
        static let StatusMsg = "error"
        static let Results = "results"
        
        //MARK: Authorization
        static let Registered = "registered"
        static let Key = "key"
        static let SessionID = "session"
        
        //MARK: Account
        static let Account = "account"
    }
}
