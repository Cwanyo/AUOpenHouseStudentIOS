//
//  SideMenuTableViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBulletin"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowEvents"), object: nil)
        case 3:
            print("logout")
        default:
            break
        }
        
    }
    
}
