//
//  OTMap_Annotation.swift
//  OnTheMap
//
//  Created by knax on 5/20/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import MapKit

class OTMap_Annotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String,subtitle:String,coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
