//
//  ViewController.swift
//  OnTheMap
//
//  Created by Heeral on 5/8/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }

}

