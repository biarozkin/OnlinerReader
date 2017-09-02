//
//  NewsManager.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class NewsManager {
    
    func getNewsData() {
        getXml()
    }
    
    private func getXml() {
        guard let url = URL(string: "https://auto.onliner.by/feed")
            else {
                print("Rss url has been changed, please check")
                return
        }
        
        Alamofire.request(url).responseString { (response) in
            switch response.result {
            case .failure(let error):
                print("Error while getting xml-data: \(error)")
                return
            case .success:
                if let data = response.result.value {
                    self.parseXml(string: data)
                }
            }
        }
    }
    
    private func parseXml(string: String) {
        var newsArray: Array<News> = []
        
        let xml = SWXMLHash.parse(string)
        
        for elem in xml["rss"]["channel"]["item"].all {
            let title = elem["title"].element?.text
            let pubDate = elem["pubDate"].element?.text
            let thumbnail = elem["media:thumbnail"].element?.attribute(by: "url")?.text
            let description = elem["description"].element?.text
            
            let newsObj = News(title: title, pubDate: pubDate, thumbnail: thumbnail, description: description)
            //print("newObj: \(newsObj)")
            
            newsArray.append(newsObj)
        }
    }
}
