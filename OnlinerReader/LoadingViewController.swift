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
        
        if Utils.isConnectedToNetwork() {
            do {
                try NewsManager.getNews { (news) in
                    for newsObj in news {
                        let newsIsOld = News.isDublicate(newsObj: newsObj)
                        if !newsIsOld {
                            do {
                                try News.saveToDisk(news: newsObj)
                            } catch {
                                Utils.showAlertWith(message: errorsDescription.badDataBaseAccess.rawValue, viewController: self, okHandler: { (alertAction) in
                                    self.goToNewsViewController()
                                    return
                                })
                            }
                        }
                    }
                    //here we are ready to go to the next VC
                    self.goToNewsViewController()
                }
            } catch {
                Utils.showAlertWith(message: errorsDescription.dataLoadingError.rawValue, viewController: self, okHandler: { (alertAction) in
                    self.goToNewsViewController()
                })
            }
        } else {
            Utils.showAlertWith(message: errorsDescription.networkDisabled.rawValue, viewController: self, okHandler: { (alertAction) in
                self.goToNewsViewController()
            })
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

