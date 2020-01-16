//
//  StringExtension.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation

extension String {
    public var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
    
    func format(_ format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dateObj = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return dateFormatter.string(from: dateObj)
        }
        return ""
    }
    
    func offsetFrom(_ format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dateObj = dateFormatter.date(from: self) {
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: dateObj, to: date)
            
            let seconds = "\(difference.second ?? 0)s ago"
            let minutes = "\(difference.minute ?? 0)m, " + " " + seconds
            let hours = "\(difference.hour ?? 0)h, " + " " + minutes
            let days = "\(difference.day ?? 0)d, " + " " + hours
            
            if let day = difference.day, day > 0 { return days }
            if let hour = difference.hour, hour > 0 { return hours }
            if let minute = difference.minute, minute > 0 { return minutes }
            if let second = difference.second, second > 0 { return seconds }
        }
        return ""
    }
}
