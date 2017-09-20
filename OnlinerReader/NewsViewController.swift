//
//  NewsViewController.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import UIKit
import QuartzCore
import RealmSwift

class NewsViewController: UITableViewController {
    
    var news: Array<News> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        prepareUI()
    }
    
    private func prepareData() {
        let localNews = News.loadFromDisk()
        if localNews == nil {
            print("Error while retrieving records from DB")
            self.showAlertWith(message: errorsDescription.badDataBaseAccess.rawValue, okHandler: { (alertAction) in })
        } else {
            news = Array(localNews!)    //if local news != nil, could we use force unwrapping than?
        }
    }
    
    private func prepareUI() {
        let onlinerLogo = UIImage(named: "onlinerLogo.png")
        let imageView = UIImageView(image: onlinerLogo)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


//MARK: - UITableViewDataSource
extension NewsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        
        cell.titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cell.titleLabel.layer.masksToBounds = true
        cell.titleLabel.layer.cornerRadius = 10
        cell.titleLabel.text = news[indexPath.row].title.stripOutHtmlTags()
        cell.dateLabel.text = news[indexPath.row].pubDate
        cell.newsImage.image = UIImage(data: news[indexPath.row].imageData)
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension NewsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.news = news[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
