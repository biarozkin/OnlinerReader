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
            let reversedNews = Array(newsData.reversed())
            completion(reversedNews)
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
                print("Error while getting xml-data: \(error.localizedDescription)")
                return
            case .success:
                if let data = response.result.value {
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
            let newsLink = elem["link"].element?.text
            let thumbnail = elem["media:thumbnail"].element?.attribute(by: "url")?.text
            let description = elem["description"].element?.text
            
            let newsObject = News()
            if let title = title {
                newsObject.title = title
            }
            if let pubDate = pubDate {
                newsObject.pubDate = Utils().shortDateFormat(string: pubDate)
            }
            if let newsLink = newsLink {
                newsObject.newsLink = newsLink
            }
            if let thumbnail = thumbnail {
                newsObject.thumbnailUrl = thumbnail
            }
            if let description = description {
                newsObject.fullDescription = Utils().removeUnnecessary(string: description)
            }
            
            newsArray.append(newsObject)
        }
        return newsArray
    }
    
    func getImageFromUrl(_ urlString: String, completion: @escaping (UIImage) -> () ) {
        guard let url = URL(string: urlString)
            else {
                print("URL with image was retrieved unsuccessfully")
                return
        }
        
        Alamofire.request(url).response { (response) in
            if let data = response.data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image!)
                }
            }
        }
    }
    
}
