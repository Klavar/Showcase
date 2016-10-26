//
//  ViewController.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 05/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {
    


    
    @IBOutlet weak var faceboookButton: FBSDKLoginButton!
   
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
    }

    @IBAction func fbButtonPressed(_ sender: UIButton!) {
            
        let facebookLogin = FBSDKLoginManager()

        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult: FBSDKLoginManagerLoginResult?, facebookError: Error?) in
            
            if facebookError != nil {
                print("Facebook login failed. Error\(facebookError)")
            }else {
                let accessToken = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print("Successfully logged in with Facebook. \(accessToken)")

                
                
                FIRAuth.auth()?.signIn(with: accessToken) { (authData, error) in
                    
                    if error != nil {
                    print("Login failed. \(error)")
                    
                    } else {
                        print("Logged in! \(authData)")
                       
                        let users = "users"
                      let user = ["provider": "Facebook"]
                        DataService.ds.createFirebaseUser(users, uid: (authData?.uid)!, user: user)
                        
                        
                        UserDefaults.standard.set(authData?.uid, forKey: KEY_UID)
                            
                            
                        self.performSegue(withIdentifier: SEGUE_USERNAME, sender: nil)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton!) {
        
        if let email = emailFeild.text, email != "", let password = passwordField.text, password != "" {
         
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            
           
                if error != nil {
                  
                print(error)
                
                
                let code = (error as! NSError).code
                    
                if code == STATUS_ACCOUNT_NONEXIST {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (result, error) in
                        
                        if error != nil {
                            self.showErrorAlert("Could not create account", message: "Problem creating account. Try something else")
                        }else {
                            UserDefaults.standard.set([KEY_UID], forKey: KEY_UID)
                            
                           
                            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (authData, err) in
                                
    
                            let users = "users"
                            let user = ["provider": authData!.providerID]
                                DataService.ds.createFirebaseUser(users, uid: (authData?.uid)!, user: user)
                            
                        })
                        
                            self.performSegue(withIdentifier: SEGUE_USERNAME, sender: nil)
                            
                        }
                }
                }else {
                    
                    self.showErrorAlert("Could not login", message: "Please check your username or password")
                }
                
                
            }else {
               self.performSegue(withIdentifier: SEGUE_USERNAME, sender: nil)
        }
    }
        }else {
            showErrorAlert("Email and Password Required", message: "You must enter an Email and Password")
            
            }
}

    
    func showErrorAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
