//
//  Ticket.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 10.04.2023.
//

import Foundation

class PassengerTicket {
    var passenger: Passenger
    var travelDate: TravelDate
    var travelHour: TravelHour
    var to: String
    var from: String
    var price: String
    var length: String
    var endTime: String
    var seatNum: String


    func compare(){

    }
    func setSeat(){

    }
    func addSeatNumber(){

    }
    func printTicket(){

    }
    
    init(passengerName:String,date:String,time:String,to:String,from:String,price:String,length:String, endTime:String, seatNum:String){
        self.passenger = Passenger(passengerName: passengerName)
        self.travelDate = TravelDate(date: date)
        self.travelHour = TravelHour(time: time)
        self.to = to
        self.from = from
        self.price = price
        self.length = length
        self.endTime = endTime
        self.seatNum = seatNum
    }
}

