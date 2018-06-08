//
//  LoginViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func googleOnClick(_ sender: UIButton) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
}
