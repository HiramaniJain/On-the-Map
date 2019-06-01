//
//  login ViewController.swift
//  OnTheMap
//
//  Created by Heeral on 5/9/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController
{
    
    @IBOutlet weak var logoUImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var dontHaveAnAccountLabel: UILabel!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton)
    {
        setLoggingIn(true)
       // OTMClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
        OTMClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        
    }
    
    @IBAction func signUPPressed(_ sender: Any)
    {
        openWithSafari("https://auth.udacity.com/sign-up")
        
    }
    func handleSessionResponse(success: Bool, error: Error?)
    {
        setLoggingIn(false)
        if success {
            // Mark:- check identifier for segue
            performSegue(withIdentifier: "LoginIdentifier", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool)
    {
        DispatchQueue.main.async {
       self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        //loginButton.isEnabled = !loggingIn
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMClient.loadStudentsInformation()
            //TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
            handleSessionResponse(success: success, error: error)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func openWithSafari(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showInfo(withMessage: "Invalid link.")
            return
        }
        UIApplication.shared.open(url, options: [:])
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
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
}
