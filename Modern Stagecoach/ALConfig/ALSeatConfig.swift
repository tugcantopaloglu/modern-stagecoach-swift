//
//  ALSeatConfig.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 9.04.2023.
//

import Foundation
import ALBusSeatView

class SeatConfig: ALBusSeatViewConfig {
    
    override init() {
        super.init()
        //Layout
        leftHandDrivePosition = true
        marginBetweenSeats = 5.0
        
        //Seat
        seatEmptyBGColor = .white
        seatSelectedBGColor = UIColor(red: 21.0 / 255.0, green: 202.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        seatSoldWomanBGColor = UIColor(red: 222/255, green: 195 / 255.0, blue: 204 / 255.0, alpha: 1.0)
        seatSoldManBGColor = UIColor(red: 168 / 255.0, green: 213 / 255.0, blue: 249/255, alpha: 1.0)
        seatCornerRadius = 10
        seatBorderColor = UIColor(red: 0/255, green: 31/255, blue: 91/255, alpha: 1.0)
        seatBorderWidth = 0.5
        seatShadowColor = UIColor(red: 146.0 / 255.0, green: 184.0 / 255.0, blue: 202.0 / 255.0, alpha: 0.5)
        seatShadowRadius = 5.0
        seatShadowOpacity = 0.7
        seatRemoveImage = UIImage(named: "iconRemoveButton")
        seatNumberFont = .systemFont(ofSize: 15)
        seatNumberSelectedFont = .systemFont(ofSize: 15)
        seatNumberColor = .black
        seatNumberSelectedColor = .white
        
        //Hall
        centerHallHeight = 40
        centerHallInfoText = ""
        centerHallInfoTextColor = .black
        centerHallInfoTextFont = .systemFont(ofSize: 12)
        
        //Bus Front Section
        busFrontImage = UIImage(named: "bus-front-view")
        busFrontImageWidth = 100
        
        //Bus Floor Section
        floorSeperatorWidth = 60
        floorSeperatorImage = UIImage(named: "bus-docker-front-view")
        
        //Gender Tooltip
        tooltipText = ""
    }
    
}

