//
//  AddLocationView.swift
//  OnTheMap
//
//  Created by Heeral on 5/24/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationView: UIViewController
{
    
    @IBOutlet weak var addLocationTextField: UITextField!
    
    @IBOutlet weak var addWebsiteTextView: UITextField!
    
    @IBAction func findLocationButton(_ sender: Any) {
        geocode(locationString: self.addLocationTextField.text!)
    }
    
    private func geocode(locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString, completionHandler: { (placemarks, error) -> Void in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
            } else {
                var location: CLLocation?
                
                if let placemark = placemarks, placemark.count > 0 {
                    location = placemark.first?.location
                }
                
                if let location = location {
                     locationCoordinate = location.coordinate
                    self.syncStudentLocation()
                } else {
                    //self.showInfo(withMessage: "No Matching Location Found")
                }
            }
        })
    }
    
    private func syncStudentLocation() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ShowLocationOnMapController") as! ShowLocationOnMapController
        getUserInformation(completion: handleUserInfoResponse(success:error:))
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func handleUserInfoResponse(success: Bool, error: Error?) {
        if success {
            //do something
        } else {
            //do something
            print("Failed to get User info")
        }
    }
    
    func getUserInformation(completion: @escaping (Bool, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/users/" + "\(String(describing: userSession.account!.key))"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(false, error)
                return
            }
            let range = (5..<data!.count)
            let newData = data!.subdata(in: range) /* subset response data! */
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                print(parsedResult)
                userInformation?.firstName = "first"
                userInformation?.lastName = "last"
                userInformation?.mapString = self.addWebsiteTextView.text!
                userInformation?.mediaURL = self.addLocationTextField.text!
                userInformation?.latitude = locationCoordinate.latitude
                userInformation?.longitude = locationCoordinate.longitude
                userInformation?.uniqueKey = userSession.account!.key
                userInformation?.objectId = ""
                userInformation?.createdAt = ""
                userInformation?.updatedAt = ""
                
            } catch {
                print(error)
            }
            
            completion(true, nil)
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
}
