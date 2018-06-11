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
    
    
//    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        print()
//        activityIndicator.stopAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
//    }
    
    @IBAction func googleOnClick(_ sender: UIButton) {
//        showLoading()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
//    func showLoading(){
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.view.addSubview(activityIndicator)
//
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
//    }
    
}
