//
//  StringUtils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 17.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func makeLinkClickableWith(header: String) -> NSAttributedString {
        let fontAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string: header, attributes: fontAttribute)
        attributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: self)! , range: NSMakeRange(0, header.characters.count))
        
        return attributedString
    }
    
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
