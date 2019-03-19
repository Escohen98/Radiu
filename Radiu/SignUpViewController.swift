//
//  SignUpViewController.swift
//  Radiu
//
//  Created by Conor Reiland on 3/18/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var loggedIn : Bool = true
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    
    
    @IBOutlet weak var signUpInputGroup: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.placeholder = "Email"
        passwordInput.placeholder = "Password"
        passwordInput.isSecureTextEntry = true
        usernameInput.placeholder = "Username"
        firstNameInput.placeholder = "First Name"
        lastNameInput.placeholder = "Last Name"
        
        signinBtn.setTitle("Sign Up", for: .normal)
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        
        signUpInputGroup.isHidden = true
        // Create the activity indicator
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5) // put in the middle
        activityIndicator.startAnimating() // Start animating
        
        let email = emailInput.text
        let password = passwordInput.text
        let username = usernameInput.text
        let first = firstNameInput.text
        let last = lastNameInput.text
        
        Repository.signUpUser(email: email, password: password, username: username, fname: first, lname: last, completion: { (token: String?) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            if token != nil {
                Repository.beginSession(token: token!)
                Repository.setToken(token: token!)
                self.performSegue(withIdentifier: "signUpSuccess", sender: self)
            } else {
                self.signInErrorAlert()
                self.signUpInputGroup.isHidden = false
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
