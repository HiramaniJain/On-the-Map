//
//  LocationCellView.swift
//  OnTheMap
//
//  Created by Heeral on 5/24/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit

class LocationCellView: UITableViewCell
{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let CellReuseIdentifier = "StudentLocationCell"
    
    func updateCell(_ studentLocation: Result) {
        let firstName = studentLocation.firstName
        let lastName = studentLocation.lastName
        
        titleLabel.text = "\(firstName ?? "No name provided") \(lastName ?? "")"
    }
}

