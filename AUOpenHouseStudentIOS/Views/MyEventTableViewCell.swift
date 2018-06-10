//
//  EventTableViewCell.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//

import UIKit

class MyEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_startTime: UILabel!
    @IBOutlet weak var lb_endTime: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img_icon.layer.cornerRadius = img_icon.frame.width / 2
        img_icon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
