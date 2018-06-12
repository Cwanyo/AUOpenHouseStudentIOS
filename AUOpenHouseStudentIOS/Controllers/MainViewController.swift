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
        
    @IBOutlet weak var lb_userName: UILabel!
    
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
                    
                    self.navigationController?.isNavigationBarHidden = false
                    self.loginViewController.view.isHidden = true
                    self.lb_userName.text = "Welcome, \(user?.displayName ?? "unknow")"
                    
                    self.loginAPI(idToken: idToken!)
                }
                
            }
        }
    }
    
    func loginAPI(idToken: String){
        RestApiProvider.login(idToken: idToken, completion: { (res) in
            if res.isSuccess {
                self.showStudentPoints()
            } else {
                // popup alert
                print(res)
                print("ERROR : Cannot connect to server")
                
                self.createAlert(title: "Alert!", message: "Cannot connect to server, some function might not available.")
            }
        })
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.logout()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func showStudentPoints(){
        RestApiProvider.getMyPoints { (s, p) in
            if s {
                print(p)
            }
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
