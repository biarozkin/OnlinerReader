//
//  Utils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 06.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

enum errorsDescription: String {
    case badDataBaseAccess = "Возникли проблемы доступа к базе данных"
    case networkDisabled = "Проверьте сетевое соединение!"
    case dataLoadingError = "Не удалось загрузить новости"
}

class Utils {
    
    static let mainURL = "https://auto.onliner.by/feed"
    
    class func makeLinkClickable(url: String) -> NSAttributedString {
        //https://stackoverflow.com/questions/34425096/how-to-display-clickable-links-in-uitextview
        let stringName = "Читать далее.."
        let fontAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string: stringName, attributes: fontAttribute)
        attributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: url)! , range: NSMakeRange(0, stringName.characters.count))
        return attributedString
    }
    
    //working with NSDate
    class func convertDateStringIntoNSDate(dateString: String) -> Date? {
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
            print("Month doesn't recognized, please have a look")
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
    
    class func shortDateFormat(string: String) -> String {
        let devidedBySpaces = string.components(separatedBy: " ")
        let formattedDate = devidedBySpaces[1] + " " + devidedBySpaces[2] + " " + devidedBySpaces[3] + " " + devidedBySpaces[4]
        
        return formattedDate
    }
    
    //figure out better name for the func :)
    class func removeUnnecessary(string: String) -> String {
        let dividedByPTag = string.components(separatedBy: "<p>")
        var usefullTextOnly = dividedByPTag[2]
        let removedLastTag = String(usefullTextOnly.characters.dropLast(4))
        
        return removedLastTag
    }
    
    class func showAlertWith(message: String, viewController: UIViewController, okHandler: @escaping (UIAlertAction) -> () ) {
        let alertController = UIAlertController(title: "Что-то пошло не так..", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
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
