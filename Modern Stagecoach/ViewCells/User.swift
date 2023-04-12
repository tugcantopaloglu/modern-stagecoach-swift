//
//  User.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 10.04.2023.
//

import UIKit

class User: UITableViewCell {

    @IBOutlet var nameSurnameTextField: UITextField!
    @IBOutlet var idNoTextField: UITextField!
    @IBOutlet var seatNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
