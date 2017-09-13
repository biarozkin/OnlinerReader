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
    
    class func getNews(completion: @escaping (Array<News>) -> () ) throws {
        getXmlString { (news) in
            if let news = news {
                let reversedNews = Array(news.reversed())
                completion(reversedNews)
            }
        }
    }
    
    class fileprivate func getXmlString(completion: @escaping (Array<News>?) -> () ) {
        guard let url = URL(string: Utils.mainURL)
            else { return }
        
        Alamofire.request(url).responseString { (response) in
            switch response.result {
            case .failure(let error):
                print("Error while getting data: \(error.localizedDescription)")
                completion(nil) //
            case .success:
                if let data = response.result.value {
                    if let news = parseXmlString(data) {
                        completion(news)
                    } else {
                        print("Error while parsing xml")
                        completion(nil)     //??
                    }
                }
            }
        }
    }
    
    class fileprivate func parseXmlString(_ string: String) -> Array<News>? {
        var newsArray: Array<News> = []
        let xml = SWXMLHash.parse(string)
        for elem in xml["rss"]["channel"]["item"].all {
            
            guard let title = elem["title"].element?.text,
                let pubDate = elem["pubDate"].element?.text,
                let newsLink = elem["link"].element?.text,
                let thumbnailUrlString = elem["media:thumbnail"].element?.attribute(by: "url")?.text,
                let description = elem["description"].element?.text else {
                    return nil
            }
            
            let newsObject = News()
            
            newsObject.title = title
            newsObject.pubDate = Utils.shortDateFormat(string: pubDate)
            newsObject.newsLink = newsLink
            newsObject.fullDescription = Utils.removeUnnecessary(string: description)
            if let thumbnailUrl = URL(string: thumbnailUrlString) {
                do {
                    let imageData = try Data(contentsOf: thumbnailUrl)
                    newsObject.imageData = imageData
                } catch let error as NSError {
                    print("Error while saving image as Data:\(error.localizedDescription)")
                }
            }
            
            newsArray.append(newsObject)
        }
        return newsArray
    }
    
}
