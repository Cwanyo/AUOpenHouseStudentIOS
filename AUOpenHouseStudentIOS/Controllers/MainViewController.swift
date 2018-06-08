//
//  HomeViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObserver()
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
    }
   
    @objc func showBulletin(){
        print("showBulletin")
        performSegue(withIdentifier: "showBulletin", sender: nil)
    }
    
    @objc func showEvents(){
        print("showEvents")
        performSegue(withIdentifier: "showEvents", sender: nil)
    }
    
}
