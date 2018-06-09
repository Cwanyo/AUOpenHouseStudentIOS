//
//  FacultyTableViewCell.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import UIKit

class FacultyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_facultyIcon: UIImageView!
    @IBOutlet weak var lb_facultyName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
