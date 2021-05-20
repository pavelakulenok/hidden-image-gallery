//
//  UIViewController+UIAlertVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

extension UIViewController {
    func showAlertWithOneButton(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
