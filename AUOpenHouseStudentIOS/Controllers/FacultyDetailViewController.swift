//
//  FacultyDetailViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import UIKit
import MapKit
import Kingfisher

class FacultyDetailViewController: UIViewController {

    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var tv_info: UITextView!
    @IBOutlet weak var cs_infoHeight: NSLayoutConstraint!
    @IBOutlet weak var tb_majors: UITableView!
    @IBOutlet weak var mp_location: MKMapView!
    
    public var faculty: Faculty?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tb_majors.dataSource = self
        tb_majors.delegate = self
        
        showDetails()
    }
    
    func showDetails(){
        let resource = ImageResource(downloadURL: (faculty?.icon)!, cacheKey: faculty?.icon?.absoluteString)
        img_icon.kf.setImage(with: resource)
        
        lb_name.text = faculty?.name
        tv_info.text = faculty?.info
        cs_infoHeight.constant = tv_info.contentSize.height
        
    }
    
}

extension FacultyDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print((faculty?.majors?.count)!)
        let i = faculty?.majors?.allObjects as! [Major]
        print("allobjcet", i.count)
        
        return (faculty?.majors?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let m = faculty?.majors?.allObjects[indexPath.row] as? Major
        
        cell.textLabel?.text = m?.name
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
}

