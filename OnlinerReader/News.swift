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
    dynamic var pubDate: String = ""     //NSDate?
    dynamic var thumbnail: String = ""   //UIImage?
    dynamic var fullDescription: String = ""

    func saveToDisk(news: News) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(news)
            }
        } catch let error as NSError {
            print("Error while saving data to disk: \(error.localizedDescription)")
        }
    }

    func loadFromDisk() -> Results<News> {
        let news = try! Realm().objects(News.self).sorted(byKeyPath: "pubDate", ascending: true)
        return news
    }
}
