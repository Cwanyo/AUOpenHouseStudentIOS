//
//  HomeViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire

class MainViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // user not login, show loginViewController
                print("Firebase: not login")
                self.navigationController?.isNavigationBarHidden = true
                self.loginViewController.view.isHidden = false
                
            }else{
                // user already logged in firebase
                print("Firebase: logged in")
                
                // login in api service
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print("ERROR : geting token",error)
                        return;
                    }
                    
                    RestApiProvider.login(idToken: idToken!, completion: { (success) in
                        if success {
                            self.navigationController?.isNavigationBarHidden = false
                            self.loginViewController.view.isHidden = true
                            self.showStudentPoints()
                        } else {
                            // TODO - popup alert
                            print("ERROR : Cannot connect to server")
                        }
                    })
                }
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func showStudentPoints(){
        RestApiProvider.getMyPoints { (t) in
            print(t)
        }
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
            print("Successfully signing out from firebase")
            
            RestApiProvider.logout { (success) in
                if success {
                    print("Successfully signing out from api")
                }
            }
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
