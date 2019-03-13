//
//  SignInViewController.swift
//  Radiu
//
//  Created by Conor Reiland on 3/11/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var loggedIn : Bool = true
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    
    
    @IBOutlet weak var loginInputGroup: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.placeholder = "Email"
        passwordInput.placeholder = "Password"
        passwordInput.isSecureTextEntry = true

        signinBtn.setTitle("Log In", for: .normal)
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        
        loginInputGroup.isHidden = true
        // Create the activity indicator
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5) // put in the middle
        activityIndicator.startAnimating() // Start animating
        
        let email = emailInput.text
        let password = passwordInput.text
        
        Repository.loginUser(email: email, password: password, completion: { (token: String?) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            if token != nil {
                Repository.beginSession(token: token!)
                Repository.initializeRepo();
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            } else {
                self.signInErrorAlert()
                self.loginInputGroup.isHidden = false
            }
            
        });
    }
    
    func signInErrorAlert(){
        let alert = UIAlertController(title: "Log In Error", message: "Incorrect Email or Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }

}
