//
//  DetailViewController.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var news = News()
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        dateLabel.text = news.pubDate
        titleLabel.text = news.title.stripOutHtmlTags()
        
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        
        let newsDescription = news.fullDescription.stripOutHtmlTags() + "\n\n"
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white]
        let attrNewsDescription: NSAttributedString = NSAttributedString(string: newsDescription, attributes: attributes)
        let newsLink = Utils().makeLinkClickable(url: news.newsLink)
        
        descriptionTextView.attributedText = attrNewsDescription + newsLink
        
        NewsManager().getImageFromUrl(news.thumbnailUrl) { (image) in
            self.newsImage.image = image
        }
    }
}
