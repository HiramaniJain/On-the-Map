//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Heeral on 5/9/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation

class OTMClient
{
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum Endpoints
    {
        static let base = "https://parse.udacity.com/parse/classes"
        static let apiKeyParam = "?api_key=\(OTMClient.apiKey)"
        
        case login
        
        var stringValue: String
        {
            switch self
            {
            case .login:
                return Endpoints.base +  Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func storeSessionId(data: Data?) -> Void
    {
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let userInfo = try jsonDecoder.decode(OTMRequest.self, from: data)
                userSession = userInfo
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
        }
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                completion(false, nil)
            case 200 ..< 299:
                break
            default:
                completion(false, nil)
            }
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            storeSessionId(data: newData)
            completion(true, nil)
        }
        task.resume()
    }
    
    class func loadStudentsInformation()
    {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
            if let data = data
            {
                let decoder = JSONDecoder()
                do {
                    let studentLocations = try decoder.decode(Locations.self, from: data)
                    
                    for loc in studentLocations.values {
                        locationResults.append(loc)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    class func parseJson(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let studentLocations = try decoder.decode(Locations.self, from: data)
            
            for loc in studentLocations.values {
                locationResults.append(loc)
            }
            
        } catch {
            print(error)
        }
    }
}
