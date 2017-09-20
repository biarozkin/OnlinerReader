//
//  Utils.swift
//  OnlinerReader
//
//  Created by Igor Biarozkin on 06.09.17.
//  Copyright © 2017 biarozkin. All rights reserved.
//

import Foundation
import UIKit

enum errorsDescription: String {
    case badDataBaseAccess = "Возникли проблемы доступа к базе данных"
    case networkDisabled = "Проверьте сетевое соединение!"
    case dataLoadingError = "Не удалось загрузить новости"
}

enum customError: Error {
    case badDataBaseAccess
    case dataLoadingError
}

class Utils {
    
    static let mainURL = "https://auto.onliner.by/feed"
    
    //figure out better name for the func :)
    class func removeUnnecessary(string: String) -> String {
        let dividedByPTag = string.components(separatedBy: "<p>")
        var usefullTextOnly = dividedByPTag[2]
        let removedLastTag = String(usefullTextOnly.characters.dropLast(4))
        
        return removedLastTag
    }
}

extension UIViewController {
    func showAlertWith(message: String, okHandler: @escaping (UIAlertAction) -> () ) {
        let alertController = UIAlertController(title: "Что-то пошло не так..", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
