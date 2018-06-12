//
//  EventDetailViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//

import UIKit
import MapKit
import Kingfisher

class EventDetailViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var img_image: UIImageView!
    @IBOutlet weak var tv_info: UITextView!
    @IBOutlet weak var cs_infoHeight: NSLayoutConstraint!
    @IBOutlet weak var tf_faculty: UITextField!
    @IBOutlet weak var tf_major: UITextField!
    @IBOutlet weak var tf_start: UITextField!
    @IBOutlet weak var tf_end: UITextField!
    @IBOutlet weak var btn_event: UIButton!
    @IBOutlet weak var mp_location: MKMapView!
    let regionRadius: CLLocationDistance = 300
    
    var checkAttend: Bool = false
    
    public var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mp_location.delegate = self

        showEvenDetails()
        checkEventAttend()
    }
    
    func checkEventAttend(){
        RestApiProvider.checkMyEventAttend(tid: (event?.tid)!) { (s,t) in
            if s {
                self.checkAttend = t
            } else {
                // error
            }
            
            self.changeBtn()
        }
    }
    
    func changeBtn(){
        if checkAttend {
            // show join
            
            btn_event.setTitle("LEAVE EVENT", for: .normal)
            btn_event.backgroundColor = UIColor(red: 0.86, green: 0.36, blue: 0.25, alpha: 1.0)
        } else {
           // show leave
            
            btn_event.setTitle("JOINT EVENT", for: .normal)
            btn_event.backgroundColor = UIColor(red: 0.29, green: 0.59, blue: 0.86, alpha: 1.0)
        }
    }
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func onEventClick(_ sender: UIButton) {
        // alert user
        if checkAttend {
            // leave event
            let alert = UIAlertController(title: "Alert!", message: "Are you sure that you want to leave this event?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.showLoading()
                RestApiProvider.leaveEvent(tid: (self.event?.tid)!) { (res) in
                    // show to user
                    self.checkEventAttend()
                    self.hideLoading()
                    self.createAlert(title: "Alert", message: res.message)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            // join event
            let alert = UIAlertController(title: "Alert!", message: "Are you sure that you want to join this event?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.showLoading()
                RestApiProvider.joinEvent(tid: (self.event?.tid)!) { (res) in
                    // show to user
                    self.checkEventAttend()
                    self.hideLoading()
                    self.createAlert(title: "Alert", message: res.message)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideLoading(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func showLoading(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEvenDetails(){
        let url = event?.image
        if url != nil {
            let resource = ImageResource(downloadURL: url!, cacheKey: url?.absoluteString)
            img_image.kf.setImage(with: resource)
        }
        
        self.navigationItem.title = event?.name
        tv_info.text = event?.info
        cs_infoHeight.constant = tv_info.contentSize.height
        
        if event?.faculty_name != nil {
            tf_faculty.text = event?.faculty_name
        }
        if event?.major_name != nil {
            tf_major.text = event?.major_name
        }
        tf_start.text = event?.time_start
        tf_end.text = event?.time_end
        
        // map
        var pinLocation = CLLocation(latitude: 13.612111, longitude: 100.837667)
        var haveLocation = false
        if ((event?.location_latitude) != 0) {
            haveLocation = true
            pinLocation = CLLocation(latitude: (event?.location_latitude)!, longitude: ((event?.location_longitude)!))
        }
        centerMapOnLocation(camLocation: pinLocation, pinLocation: pinLocation, pin: haveLocation)
    }
    
    func centerMapOnLocation(camLocation: CLLocation, pinLocation: CLLocation, pin: Bool) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(camLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mp_location.setRegion(coordinateRegion, animated: true)
        
        if pin == false {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = event?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: pinLocation.coordinate.latitude, longitude: pinLocation.coordinate.longitude)
        mp_location.addAnnotation(annotation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ChatVC = segue.destination as? ChatViewController else {return}
        ChatVC.event = event
    }
}
