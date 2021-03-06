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
        do {
            guard let localNews = try News.loadFromDisk() else {
                return
            }
            news = Array(localNews)
        } catch let error as NSError {
            print("Error while retrieving records from DB:\(error.localizedDescription)")
            Utils.showAlertWith(message: errorsDescription.badDataBaseAccess.rawValue, viewController: self, okHandler: { (alertAction) in })
        }
        
    }
    
    private func prepareUI() {
        let onlinerLogo = UIImage(named: "onlinerLogo.png")
        let imageView = UIImageView(image: onlinerLogo)
        navigationItem.titleView = imageView
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        ////allows table view to use dynamic height cells
        //tableView.estimatedRowHeight = 140
        //tableView.rowHeight = UITableViewAutomaticDimension
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
