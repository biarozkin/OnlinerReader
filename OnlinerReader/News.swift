//
//  News.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation

struct News {
    var title: String? = nil
    var pubDate: String? = nil      //NSDate?
    var thumbnail: String? = nil    //UIImage?
    var description: String? = nil
    
    init(title: String?, pubDate: String?, thumbnail: String?, description: String?) {
        self.title = title
        self.pubDate = pubDate
        self.thumbnail = thumbnail
        self.description = description
    }
}
