//
//  BulletinViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit
import Kingfisher

class BulletinViewController: UIViewController {

    @IBOutlet weak var tb_faculties: UITableView!
    
    var faculties = [Faculty]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb_faculties.dataSource = self
        tb_faculties.delegate = self

        getListOfFaculties()
    }
    
    func getListOfFaculties(){
        RestApiProvider.getFaculties { (s, f) in
            if s {
                self.faculties = f
            } else {
                // load from coredata
            }
            self.tb_faculties.reloadData()
        }
    }

}

extension BulletinViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFaculty", for: indexPath) as! FacultyTableViewCell
        
        let iconUrl = faculties[indexPath.row].icon
        let resource = ImageResource(downloadURL: iconUrl!, cacheKey: iconUrl?.absoluteString)
        cell.img_facultyIcon.kf.setImage(with: resource)
        
        cell.lb_facultyName.text = faculties[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFacultyDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let facultyDetailVC = segue.destination as? FacultyDetailViewController else {return}
        facultyDetailVC.faculty = faculties[(tb_faculties.indexPathForSelectedRow?.row)!]
    }
    
}
