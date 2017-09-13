//
//  News.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import RealmSwift

class News: Object {
    
    dynamic var title: String = ""
    dynamic var pubDate: String = ""                //dynamic var pubDate: Date = Date()
    dynamic var newsLink: String = ""
    dynamic var imageData: Data = Data()
    dynamic var fullDescription: String = ""

    class func saveToDisk(news: News) throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(news)
            }
        } catch let error as NSError {
            print("Error while saving data to disk: \(error.localizedDescription)")
        }
        
    }
    
    class func loadFromDisk() throws -> Results<News>? {
        do {
            let news = try Realm().objects(News.self).sorted(byKeyPath: "pubDate", ascending: false)
            return news
        } catch let error as NSError {
            print("Error while reading data from disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func isDublicate(newsObj: News) -> Bool {
        do {
            let isRealmEmpty = try Realm().isEmpty
            if isRealmEmpty {
                return false
            } else {
                //local news-object
                guard let newsFromDB = try loadFromDisk() else {
                    return true
                }
                let lastLocalPubDate = newsFromDB.first?.value(forKeyPath: "pubDate") as! String
                let lastLocalPubDateInSecs = Utils.convertDateStringIntoNSDate(dateString: lastLocalPubDate)?.timeIntervalSince1970
                let lastLocalPubDateInSecsInt = Int(lastLocalPubDateInSecs!)
                
                //news-object from internet
                let pubDate = newsObj.value(forKeyPath: "pubDate") as! String
                let pubDateInSecs = Utils.convertDateStringIntoNSDate(dateString: pubDate)?.timeIntervalSince1970
                let pubDateInSecsInt = Int(pubDateInSecs!)
                
                //checking if news-object from internet is already exist in DB
                if lastLocalPubDateInSecsInt >= pubDateInSecsInt {
                    return true
                } else {
                    return false
                }
            }
        } catch let error as NSError {
            print("Failed while checking on RealmDB emptyness:\(error.localizedDescription)")
            return true
        }
    }
    
}
