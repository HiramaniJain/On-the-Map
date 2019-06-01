//
//  UserResponse.swift
//  OnTheMap
//
//  Created by Heeral on 5/10/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation

var userSession: OTMRequest!

struct OTMRequest: Codable {
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
