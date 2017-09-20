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
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //path to realm DB file
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard Reachability.isConnectedToNetwork() else {
            showAlertWith(message: errorsDescription.networkDisabled.rawValue, okHandler: { (alertAction) in
                self.goToNewsViewController()
            })
            return
        }
        
        NewsManager.getNews { (news) in
            if news == nil {
                self.showAlertWith(message: errorsDescription.dataLoadingError.rawValue, okHandler: { (alertAction) in
                    self.goToNewsViewController()
                })
            } else {
                var lastLocalPubdate = Int()
                var isRealmEmpty: Bool = true
                isRealmEmpty = News.isRealmEmpty()
                if !isRealmEmpty {
                    lastLocalPubdate = News.getLastPubLocalDate()
                    if lastLocalPubdate == 0 {
                        self.showAlertWith(message: errorsDescription.dataLoadingError.rawValue, okHandler: { (alertAction) in
                            self.goToNewsViewController()
                            return
                        })
                    }
                }
                
                for newsObj in news! {
                    if isRealmEmpty {
                        do {
                            try News.saveToDisk(news: newsObj)
                        } catch {
                            self.showAlertWith(message: errorsDescription.badDataBaseAccess.rawValue, okHandler: { (alertAction) in
                                self.goToNewsViewController()
                                return
                            })
                        }
                        isRealmEmpty = false
                    } else {
                        let isDublicate = News.checkNewsForDublicateUsing(lastLocalPubDate: lastLocalPubdate, newsObj: newsObj)
                        if !isDublicate {
                            do {
                                try News.saveToDisk(news: newsObj)
                            } catch {
                                self.showAlertWith(message: errorsDescription.badDataBaseAccess.rawValue, okHandler: { (alertAction) in
                                    self.goToNewsViewController()
                                    return
                                })
                            }
                        }
                    }
                }
                self.goToNewsViewController()
            }
        }
    }
    
    //MARK: - UI Preferences
    fileprivate func prepareUI() {
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.startAnimating()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func goToNewsViewController() {
        self.loadingActivityIndicator.stopAnimating()
        self.performSegue(withIdentifier: "toNewsVC", sender: self)
    }
}
