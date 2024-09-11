//
//  CurrentDate.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation

extension Date {
    static func currentDay() -> Self {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if let year = components.year, let month = components.month, let day = components.day {
            let dateWithoutTime = calendar.date(from: DateComponents(year: year, month: month, day: day))
            return dateWithoutTime ?? Date()
        }
        return Date()
    }
}
