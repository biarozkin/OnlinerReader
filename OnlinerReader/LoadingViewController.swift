//
//  LoadingViewController.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 05.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import UIKit
import RealmSwift

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        //path to realm DB file
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        NewsManager().getNews { (news) in
            for newsObj in news {
                News().saveToDisk(news: newsObj)
            }
            //here we are ready to go to the next VC
            self.performSegue(withIdentifier: "toNewsVC", sender: self)
        }
        
    }
    
    fileprivate func prepareUI() {
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.startAnimating()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toNewsVC" {
//            let newsVC = storyboard?.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
//            navigationController?.pushViewController(newsVC, animated: true)
//        }
//    }
}

