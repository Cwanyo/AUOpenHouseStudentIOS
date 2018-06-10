//
//  MyEventsViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//

import UIKit
import Kingfisher

class MyEventsViewController: UIViewController {

    @IBOutlet weak var tb_myevents: UITableView!
    
    var myevents = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb_myevents.dataSource = self
        tb_myevents.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getListOfUpcomingEvets()
    }
    
    func getListOfUpcomingEvets(){
        RestApiProvider.getMyEvents { (s, e) in
            if s {
                self.myevents = e
            } else {
                // load from coredata
            }
            self.tb_myevents.reloadData()
        }
    }


}

extension MyEventsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyEvent", for: indexPath) as! MyEventTableViewCell
        
        let iconUrl = myevents[indexPath.row].image
        if iconUrl != nil {
            let resource = ImageResource(downloadURL: iconUrl!, cacheKey: iconUrl?.absoluteString)
            cell.img_icon.kf.setImage(with: resource)
        }
        
        cell.lb_name.text = myevents[indexPath.row].name
        
        cell.lb_startTime.text = "Start : " + convStringToDate(sTime: myevents[indexPath.row].time_start!)
        cell.lb_endTime.text = "End   : " + convStringToDate(sTime: myevents[indexPath.row].time_end!)
        
        return cell
    }
    
    func convStringToDate(sTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: sTime)
        
        dateFormatter.dateFormat = "dd MMM HH:mm"
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEventDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let eventDetailVC = segue.destination as? EventDetailViewController else {return}
        eventDetailVC.event = myevents[(tb_myevents.indexPathForSelectedRow?.row)!]
    }
    
}
