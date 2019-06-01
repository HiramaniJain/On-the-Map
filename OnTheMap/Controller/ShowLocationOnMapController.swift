//
//  ShowLocationOnMapController.swift
//  OnTheMap
//
//  Created by Heeral on 5/24/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ShowLocationOnMapController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapViewShow: MKMapView!
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        updateStudentInformation(completion: handleUpdateResponse(success:error:))
    }
    
    func showUpdateFailure(message: String) {
        let alertVC = UIAlertController(title: "Update Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleUpdateResponse(success: Bool, error: Error?) {
        if success {
            //do something
        } else {
            showUpdateFailure(message: error?.localizedDescription ?? "")
        }
    }
    
     func updateStudentInformation(completion: @escaping (Bool, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/" + "\(String(describing: userSession.account!.key))"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(String(describing: userInformation?.uniqueKey))\", \"firstName\": \"\(String(describing: userInformation?.firstName))\", \"lastName\": \"\(String(describing: userInformation?.lastName))\",\"mapString\": \"\(String(describing: userInformation?.mapString))\", \"mediaURL\": \"\(webAddress)\",\"latitude\": \(locationCoordinate.latitude), \"longitude\": \(locationCoordinate.longitude)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapViewShow.delegate = self
        self.showLocation()
    }
    
    private func showLocation() {
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = webAddress
        
        self.mapViewShow.addAnnotation(annotation)
    }
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.mapViewShow.alpha = 0.5
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.mapViewShow.alpha = 1
            self.showLocation()
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    private class func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    private class func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
