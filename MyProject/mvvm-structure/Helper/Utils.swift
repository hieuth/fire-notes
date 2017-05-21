//
//  Utils.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/21/17.
//  All rights reserved.
//

import Foundation
struct Utils {
    static func dynamicDateString(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let format = Calendar.current.isDateInToday(date)
            ? Constants.timeFormatString
            : Constants.dateFormatString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func dateString(from date: Date) -> String {
        let format = Constants.dateFormatString + " " + Constants.timeFormatString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func date(from string: String) -> Date {
        let format = Constants.dateFormatString + " " + Constants.timeFormatString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string) ?? Date()
    }
}
