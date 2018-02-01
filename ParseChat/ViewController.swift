//
//  ViewController.swift
//  ParseChat
//
//  Created by Nikhil Iyer on 1/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var ifLoggedInSuccessfully = "Hi";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(_ sender: Any) {
        registerUser()
    }

    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameLabel.text
        //newUser.email = emailLabel.text
        newUser.password = passwordLabel.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }   
    }
    
    @IBAction func login(_ sender: Any) {
        loginUser()
    }
    
    func loginUser() {
        
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.ifLoggedInSuccessfully = "Success"
                if(self.ifLoggedInSuccessfully == "Success"){
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                // display view controller that needs to shown after successful login
            }
        }
        
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: self) {
//        
//    }
    
    
}

