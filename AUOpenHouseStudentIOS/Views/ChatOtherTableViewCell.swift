//
//  ChatOtherTableViewCell.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 11/6/2561 BE.
//

import UIKit

class ChatOtherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lb_otherName: UILabel!
    @IBOutlet weak var tv_otherMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
