//
//  NewsViewController.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 01.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {

    let news = News().loadFromDisk()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
    }
    
    func prepareUI() {
        title = "auto.onliner.by"
        
        //allows table view to use dynamic height cells
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

//MARK: - UITableViewDataSource
extension NewsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        
        cell.titleLabel.text = "Some Title"
        cell.dateLabel.text = "DATE"
        cell.descriptionLabel.text = "A lot of text just for testfsdfsfdsgdfsg fdsg sdfg dsfg sdfg sdfg dsfg sdfg sdfgdscgdsfg sdh sdg msdlkfg sdjgoi jsdoifgos dofgnds oingfisdni fugnisdubng sdfg check check"
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension NewsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
