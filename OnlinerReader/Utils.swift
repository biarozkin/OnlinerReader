//
//  Utils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 06.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static let mainURL = "https://auto.onliner.by/feed"
    
    func makeLinkClickable(url: String) -> NSAttributedString {
        //https://stackoverflow.com/questions/34425096/how-to-display-clickable-links-in-uitextview
        let stringName = "Читать далее.."
        let fontAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string: stringName, attributes: fontAttribute)
        attributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: url)! , range: NSMakeRange(0, stringName.characters.count))
        return attributedString
    }
    
    //working with NSDate
    func convertDateStringIntoNSDate(dateString: String) -> Date? {
        //workAround, figure out better solution
        let devidedBySpaces = dateString.components(separatedBy: " ")
        let monthValue = devidedBySpaces[1].lowercased()
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
            print("Month doesn't recognized, plese have a look")
        }
        
        let rewrittenDate = devidedBySpaces[0] + " " + monthString + " " + devidedBySpaces[2] + " " + devidedBySpaces[3]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        
        if let dateFromString = dateFormatter.date(from: rewrittenDate) {
            return dateFromString
        } else {
            return nil
        }
    }
    
    func shortDateFormat(string: String) -> String {
        let devidedBySpaces = string.components(separatedBy: " ")
        let formattedDate = devidedBySpaces[1] + " " + devidedBySpaces[2] + " " + devidedBySpaces[3] + " " + devidedBySpaces[4]
        
        return formattedDate
    }
    
    //figure out better name for the func :)
    func removeUnnecessary(string: String) -> String {
        let dividedByPTag = string.components(separatedBy: "<p>")
        var usefullTextOnly = dividedByPTag[2]
        let removedLastTag = String(usefullTextOnly.characters.dropLast(4))
        
        return removedLastTag
    }
    
}

//MARK: - Strings extensions
extension String {
    func stripOutHtmlTags() -> String {
        let removeHtmlAttributes = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let removeNBSPAsWell = removeHtmlAttributes.replacingOccurrences(of: "&nbsp;", with: " ")
        
        return removeNBSPAsWell
    }
}

extension NSAttributedString {
    static func + (firstAttrSting: NSAttributedString, secondAttrSting: NSAttributedString) -> NSAttributedString
    {
        let concatenatedString = NSMutableAttributedString()
        concatenatedString.append(firstAttrSting)
        concatenatedString.append(secondAttrSting)
        return concatenatedString
    }
    
}
