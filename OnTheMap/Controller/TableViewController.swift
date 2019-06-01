//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Heeral on 5/24/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController
{
    
    @IBOutlet var tableViewStudents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewStudents.delegate = self
        tableViewStudents.dataSource = self
        
        tableViewStudents.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = locationResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCellView.CellReuseIdentifier, for: indexPath) as! LocationCellView
        
        cell.updateCell(studentLocation)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = locationResults[indexPath.row]
        openUrl(url: studentLocation.mediaURL)
        // Deselect the selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func openUrl(url: String?) {
        if let url = URL(string: url!) {
            let app = UIApplication.shared
            app.open(url, options: [:], completionHandler: nil)
        } else {
            showAlertDialog(title: "Ooops!", message: "The media URL provided by this student is not a valid URL", dismissHandler: nil)
        }
    }
}

extension UIViewController {
    
    func showAlertDialog(title: String, message: String, dismissHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: dismissHandler))
        self.present(alert, animated: true)
    }
}
