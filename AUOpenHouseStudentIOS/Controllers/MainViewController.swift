//
//  HomeViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // if user not login, show loginViewController
                print("not log in")
                self.navigationController?.isNavigationBarHidden = true
                self.loginViewController.view.isHidden = false
                
            }else{
                // if user already logged in, show main
                print("logged in")
                self.navigationController?.isNavigationBarHidden = false
                self.loginViewController.view.isHidden = true
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // Login view
    lazy var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        
        addChildViewController(childViewController)
        
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func onMenuClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    func createObserver(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showBulletin),
                                               name: NSNotification.Name("ShowBulletin"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showEvents),
                                               name: NSNotification.Name("ShowEvents"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logout),
                                               name: NSNotification.Name("logout"),
                                               object: nil)
    }
   
    @objc func showBulletin(){
        print("showBulletin")
        performSegue(withIdentifier: "showBulletin", sender: nil)
    }
    
    @objc func showEvents(){
        print("showEvents")
        performSegue(withIdentifier: "showEvents", sender: nil)
    }
    
    @objc func logout(){
        print("logout")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("Successfully signing out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
