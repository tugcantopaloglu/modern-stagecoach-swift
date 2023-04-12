//
//  BoughtTicket.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 10.04.2023.
//

import UIKit

class BoughtTicket: UITableViewCell {

    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var passengerLabel: UILabel!
    @IBOutlet var seatNumLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var ticketCostLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
