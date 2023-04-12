//
//  Date+Extension.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 11.04.2023.
//

import Foundation

extension Date {
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
