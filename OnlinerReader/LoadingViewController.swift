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
        
        //path to realm DB file
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        prepareUI()
        
        NewsManager().getNews { (news) in
            for newsObj in news {
                let newsIsOld = News().isDublicate(newsObj: newsObj)
                if !newsIsOld {
                    News().saveToDisk(news: newsObj)
                }
            }
            
            //here we are ready to go to the next VC    //?
            self.loadingActivityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toNewsVC", sender: self)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    fileprivate func prepareUI() {
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.startAnimating()
    }
    
}

