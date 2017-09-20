//
//  DateUtils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 17.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation

class DateUtils {
    
    class func convertDateStringIntoNSDate(dateString: String) -> Date? {
        
        let removeOther = dateString.components(separatedBy: " ")
        let formattedDate = removeOther[1] + " " + removeOther[2] + " " + removeOther[3] + " " + removeOther[4]
        let dividedBySpaces = formattedDate.components(separatedBy: " ")
        
        let monthValue = dividedBySpaces[1].lowercased()
        var monthString = ""
        switch monthValue {
        case "jan":
            monthString = "01"
        case "feb":
            monthString = "02"
        case "mar":
            monthString = "03"
        case "apr":
            monthString = "04"
        case "may":
            monthString = "05"
        case "jun":
            monthString = "06"
        case "jul":
            monthString = "07"
        case "aug":
            monthString = "08"
        case "sep":
            monthString = "09"
        case "oct":
            monthString = "10"
        case "nov":
            monthString = "11"
        case "dec":
            monthString = "12"
        default:
            monthString = "01"
            print("Month doesn't recognized, please have a look")
        }
        
        let rewrittenDate = dividedBySpaces[0] + " " + monthString + " " + dividedBySpaces[2] + " " + dividedBySpaces[3]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        
        if let dateFromString = dateFormatter.date(from: rewrittenDate) {
            return dateFromString
        } else {
            return nil
        }
    }
    
}
