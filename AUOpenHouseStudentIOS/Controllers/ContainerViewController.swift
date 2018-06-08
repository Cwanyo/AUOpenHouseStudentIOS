//
//  ContainerViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var cs_sideMenu: NSLayoutConstraint!
    
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu(){
        if sideMenuOpen {
            cs_sideMenu.constant = -250
            sideMenuOpen = false
        }else{
            cs_sideMenu.constant = 0
            sideMenuOpen = true
        }
        UIView.animate(withDuration: 0.2){
            self.view.layoutIfNeeded()
        }
    }
    
}
