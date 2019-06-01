//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Heeral on 5/11/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate
{
   
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addLocationTapped(_ sender: Any) {
         //performSegue(withIdentifier: "LoginIdentifier", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
        self.showStudentsInformation()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showLogoutFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLogoutFailure(message: String) {
        let alertVC = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showInfo(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    
    private func showStudentsInformation() {
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locationResults {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = dictionary.firstName
            let lastName = dictionary.lastName
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName ?? "No name provided") \(lastName ?? "")"
            annotation.subtitle = dictionary.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 0.5
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 1
            self.showStudentsInformation()
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

extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let reloadStarted = Notification.Name("reloadStarted")
    static let reloadCompleted = Notification.Name("reloadCompleted")
}
