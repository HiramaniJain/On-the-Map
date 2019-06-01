//
//  OMTResponse.swift
//  OnTheMap
//
//  Created by Heeral on 5/10/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import MapKit

var locationCoordinate = CLLocationCoordinate2D()
var webAddress = String()
var userId = String()


var locationResults = [Result]()

struct Locations: Decodable {
    let values: [Result]
    
    enum CodingKeys : String, CodingKey {
        case values = "results"
    }
}

var userInformation:student?

struct student {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
}

struct Result: Decodable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
}
