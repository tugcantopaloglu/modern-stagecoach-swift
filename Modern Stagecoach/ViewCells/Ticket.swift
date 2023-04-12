//
//  Ticket.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 10.04.2023.
//

import UIKit

class Ticket: UITableViewCell {
    
    @IBOutlet var busImages: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var destination1Label: UILabel!
    @IBOutlet weak var destination2Label: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(model: DestinationModel) {
        self.busImages.image = UIImage(named: model.travelModel!.image!)
        self.timeLabel.text = model.travelModel!.time!
        self.priceLabel.text = model.travelModel!.price!
        self.travelTimeLabel.text = model.travelModel!.travelTime!
        self.destination1Label.text = model.startDestination
        self.destination2Label.text = model.endDestination
        self.dateLabel.text = model.date
    }
}
