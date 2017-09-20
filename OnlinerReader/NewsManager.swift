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
    
    class func getNews(completion: @escaping (Array<News>?) -> () ) {
        getXmlString { (news) in
            if let news = news {
                let reversedNews = Array(news.reversed())
                completion(reversedNews)
            } else {
                print("we are here")
                completion(nil)
            }
        }
    }
    
    class fileprivate func getXmlString(completion: @escaping (Array<News>?) -> () ) {
        
        guard let url = URL(string: Utils.mainURL) else { return }
        
        Alamofire.request(url).responseString { (response) in
            switch response.result {
            case .failure(let error):
                print("Error while getting data: \(error.localizedDescription)")
                completion(nil)
            case .success:
                if let data = response.result.value {
                    let news = parseXmlString(data)
                    if news == nil {
                        print("Parsing process was unsuccessfull")
                        completion(nil)
                    } else {
                        completion(news)
                    }
                }
            }
        }
    }
    
    class fileprivate func parseXmlString(_ string: String) -> Array<News>? {
        
        var newsArray: Array<News> = []
        let xml = SWXMLHash.parse(string)
        
        for elem in xml["rss"]["channel"]["item"].all {
            let title = elem["title"].element?.text
            let pubDate = elem["pubDate"].element?.text
            let newsLink = elem["link"].element?.text
            let thumbnailUrlString = elem["media:thumbnail"].element?.attribute(by: "url")?.text
            let description = elem["description"].element?.text
            
            let newsObject = News()
            
            if let title = title {
                newsObject.title = title
            } else {
                print("Issue while parsing title property")
            }
            
            if let pubDate = pubDate {
                newsObject.pubDate = pubDate
            } else {
                print("Issue while parsing pubDate property")
            }
            
            if let newsLink = newsLink {
                newsObject.newsLink = newsLink
            } else {
                print("Issue while parsing newsLink property")
            }
            
            //            DispatchQueue.global().async {
            if let thumbnailUrlString = thumbnailUrlString {
                if let thumbnailUrl = URL(string: thumbnailUrlString) {
                    do {
                        let imageData = try Data(contentsOf: thumbnailUrl)
                        newsObject.imageData = imageData
                    } catch {//let error as NSError {
                        print("Error while saving image as Data:\(error.localizedDescription)")
                    }
                }
            } else {
                print("Issue while parsing thumbnailUrlString property")
            }
            
            if let description = description {
                newsObject.fullDescription = Utils.removeUnnecessary(string: description)
            } else {
                print("Issue while parsing description property")
            }
            
            newsArray.append(newsObject)
        }
        return newsArray
    }
    
}
