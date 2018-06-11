//
//  ChatUserTableViewCell.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 11/6/2561 BE.
//

import UIKit

class ChatUserTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_userName: UILabel!
    @IBOutlet weak var tv_userMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
