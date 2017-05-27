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

        static let PostURL = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let SignUpURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static let UserApi = "https://www.udacity.com/api/users/"
    }
      struct JSONResponseKeys {
        //MARK: General
        static let Results = "results"
    
        
        //MARK: Authorization
        static let SessionID = "session"
        static let Account = "account"
        static let User = "user"
    }
    
    struct DefaultURL {
        static let standInURL = "http://www.udacity.com"
    }
}
