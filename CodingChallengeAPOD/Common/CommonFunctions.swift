//
//  CommonFunctions.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 11/4/22.
//

import Foundation
import UIKit

class  CommonFunctions {
    typealias YesActionCompletionBlock = ()-> Void
    
    static func showAlertActionView(title: String, message: String, controller: UIViewController, yesAction: YesActionCompletionBlock? = nil){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.Alerts.kYes, style: UIAlertAction.Style.default, handler: { _ in
            yesAction?()
        }))
        alert.addAction(UIAlertAction(title: Constants.Alerts.kNo, style: UIAlertAction.Style.default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlert(title: String, message: String, controller: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.Strings.kOkay, style: UIAlertAction.Style.default))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
