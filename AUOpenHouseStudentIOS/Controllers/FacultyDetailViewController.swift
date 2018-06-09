//
//  FacultyDetailViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import UIKit
import MapKit
import Kingfisher

class FacultyDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var tv_info: UITextView!
    @IBOutlet weak var cs_infoHeight: NSLayoutConstraint!
    @IBOutlet weak var tb_majors: UITableView!
    @IBOutlet weak var mp_location: MKMapView!
    let regionRadius: CLLocationDistance = 300
    
    public var faculty: Faculty?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tb_majors.dataSource = self
        tb_majors.delegate = self
        mp_location.delegate = self
        
        showDetails()
    }
    
    func showDetails(){
        let resource = ImageResource(downloadURL: (faculty?.icon)!, cacheKey: faculty?.icon?.absoluteString)
        img_icon.kf.setImage(with: resource)
        
        lb_name.text = faculty?.name
        tv_info.text = faculty?.info
        cs_infoHeight.constant = tv_info.contentSize.height
        
        // map
        // let camLocation = CLLocation(latitude: 13.612111, longitude: 100.837667)
        let pinLocation = CLLocation(latitude: (faculty?.location_latitude)!, longitude: ((faculty?.location_longitude)!))
        centerMapOnLocation(camLocation: pinLocation, pinLocation: pinLocation)
    }
    
    func centerMapOnLocation(camLocation: CLLocation, pinLocation: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(camLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mp_location.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = faculty?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: pinLocation.coordinate.latitude, longitude: pinLocation.coordinate.longitude)
        mp_location.addAnnotation(annotation)
    }
    
    @IBAction func visitOnClick(_ sender: UIButton) {
        let url = faculty?.website
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
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
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
}

