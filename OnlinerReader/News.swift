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
    dynamic var pubDate: String = ""
    dynamic var newsLink: String = ""
    dynamic var imageData: Data = Data()
    dynamic var fullDescription: String = ""
    
    //MARK: - Main operations
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
    
    class func loadFromDisk() -> Results<News>? {
        do {
            let news = try Realm().objects(News.self).sorted(byKeyPath: "pubDate", ascending: false)
            return news
        } catch let error as NSError {
            print("Error while reading data from disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func isRealmEmpty() -> Bool {
        do {
            let isRealmEmpty = try Realm().isEmpty
            if isRealmEmpty {
                return true
            } else {
                return false
            }
        } catch {
            print("Error while accessing DB: isRealmEmpty()")
            return true
        }
    }
    
    //MARK: - additional instruments
    class func checkNewsForDublicateUsing(lastLocalPubDate: Int, newsObj: News) -> Bool {
        let pubDate = newsObj.value(forKeyPath: "pubDate") as! String
        let pubDateInSecs = DateUtils.convertDateStringIntoNSDate(dateString: pubDate)?.timeIntervalSince1970
        let pubDateInSecsInt = Int(pubDateInSecs!)
        
        //checking if news-object from internet is already exist in DB
        if lastLocalPubDate >= pubDateInSecsInt {
            return true
        } else {
            return false
        }
    }
    
    class func getLastPubLocalDate() -> Int {
        guard let newsFromDB = loadFromDisk()
            else { return 0 }
        
        let lastLocalPubDate = newsFromDB.first?.value(forKeyPath: "pubDate") as! String
        let lastLocalPubDateInSecs = DateUtils.convertDateStringIntoNSDate(dateString: lastLocalPubDate)?.timeIntervalSince1970
        let lastLocalPubDateInSecsInt = Int(lastLocalPubDateInSecs!)
        
        return lastLocalPubDateInSecsInt
    }
}
