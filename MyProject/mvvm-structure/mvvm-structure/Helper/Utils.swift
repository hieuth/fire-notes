//
//  Utils.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/21/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation
struct Utils {
    static func dynamicDateString(from date: Date) -> String {
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
}
