//
//  UpEventsViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//

import UIKit
import Kingfisher

class UpEventsViewController: UIViewController {
    
    @IBOutlet weak var tb_upevents: UITableView!
    
    var upevents = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb_upevents.dataSource = self
        tb_upevents.delegate = self
        
        getListOfUpcomingEvets()
    }
    
    func getListOfUpcomingEvets(){
        RestApiProvider.getUpEvents { (s, e) in
            if s {
                self.upevents = e
            } else {
                // load from coredata
            }
            self.tb_upevents.reloadData()
        }
    }

}

extension UpEventsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUpEvent", for: indexPath) as! UpEventTableViewCell
        
        let iconUrl = upevents[indexPath.row].image
        if iconUrl != nil {
            let resource = ImageResource(downloadURL: iconUrl!, cacheKey: iconUrl?.absoluteString)
            cell.img_icon.kf.setImage(with: resource)
        }
        
        cell.lb_name.text = upevents[indexPath.row].name
        
        cell.lb_info.text = upevents[indexPath.row].info
        cell.lb_startTime.text = "Start : " + convStringToDate(sTime: upevents[indexPath.row].time_start!)
        
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "showFacultyDetail", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let facultyDetailVC = segue.destination as? FacultyDetailViewController else {return}
//        facultyDetailVC.faculty = upevents[(tb_faculties.indexPathForSelectedRow?.row)!]
//    }
    
}
