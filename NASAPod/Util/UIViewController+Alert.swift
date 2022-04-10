//
//  UIViewController+Alert.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import UIKit

/**
 This extension on UIViewController provides easy to use alert display methods and handlers
 */

extension UIViewController {
    
    /**
     Shows an error in an alert
     */
    func showError(_ error: Failure, postDismisshandler handler: @escaping () -> Void) {
        showAlert(withTitle: "Error", message: error.message, postDismisshandler: handler)
    }
    
    /**
     Shows an alert with provided title, message and 'Ok' button
     postDismisshandler will be called on 'Ok' button tap and alert dismissal
     */
    func showAlert(withTitle title: String?, message: String?, okButtonTitle: String = "Ok", postDismisshandler handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: okButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            handler()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
