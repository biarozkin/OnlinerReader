//
//  Utils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 06.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation

class Utils {
    
    static let mainURL = "https://auto.onliner.by/feed"
    
    func convertDate(string: String) -> String {
        let devidedBySpaces = string.components(separatedBy: " ")
        let formattedDate = devidedBySpaces[1] + " " + devidedBySpaces[2] + " " + devidedBySpaces[3] + " " + devidedBySpaces[4]
        
        return formattedDate
    }
    
    //figure out more better name for the func :)
    func removeUnnecessary(string: String) -> String {
        let dividedByPTag = string.components(separatedBy: "<p>")
        var usefullTextOnly = dividedByPTag[2]
        let removedLastTag = String(usefullTextOnly.characters.dropLast(4))
        
        return removedLastTag
    }
    
}
