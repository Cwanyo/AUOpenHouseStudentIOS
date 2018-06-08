//
//  SideMenuTableViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit
import Firebase
import GoogleSignIn
import Kingfisher

class SideMenuTableViewController: UITableViewController {
    
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounded user image
        img_profile.layer.cornerRadius = img_profile.frame.width / 2
        img_profile.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                
                // set picture and name of the user
                let resource = ImageResource(downloadURL: (user?.providerData[0].photoURL)!, cacheKey: user?.providerData[0].photoURL?.absoluteString)
                self.img_profile.kf.setImage(with: resource)
                
                self.lb_name.text = user?.displayName
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBulletin"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowEvents"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
        default:
            break
        }
        
    }
    
}
