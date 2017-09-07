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
    
    func getNews(completion: @escaping (Array<News>) -> () ) {
        getXmlString { (dataString) in
            let newsData = self.parseXmlString(dataString)
            completion(newsData)
        }
    }
    
    fileprivate func getXmlString(completion: @escaping (String) -> () ) {
        guard let url = URL(string: Utils.mainURL)
            else {
                print("Rss URL has been changed or it's unreachable at the moment, please check")
                return
        }
        
        Alamofire.request(url).responseString { (response) in
            switch response.result {
            case .failure(let error):
                print("Error while getting xml-data: \(error)")
                return
            case .success:
                if let data = response.result.value {
                    //completion(self.parseXmlUsing(string: data))
                    completion(data)
                }
            }
        }
    }
    
    fileprivate func parseXmlString(_ string: String) -> Array<News> {
        var newsArray: Array<News> = []
        let xml = SWXMLHash.parse(string)
        for elem in xml["rss"]["channel"]["item"].all {
            let title = elem["title"].element?.text
            let pubDate = elem["pubDate"].element?.text
            let thumbnail = elem["media:thumbnail"].element?.attribute(by: "url")?.text
            let description = elem["description"].element?.text
            
            let newsObject = News()
            if let title = title {
                newsObject.title = title
            }
            if let pubDate = pubDate {
                newsObject.pubDate = Utils().convertDate(string: pubDate)
            }
            if let thumbnail = thumbnail {
                newsObject.thumbnail = thumbnail
            }
            if let description = description {
                newsObject.fullDescription = Utils().removeUnnecessary(string: description)
            }
            
            newsArray.append(newsObject)
        }
        return newsArray
    }
}
