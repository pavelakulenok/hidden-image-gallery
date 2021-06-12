//
//  PasswordVerificationVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class PasswordVerificationVC: UIViewController {
    private let password = "123"

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.applyCornerRadius(goButton.frame.width / 2)
        passwordTextField.delegate = self
    }

    @IBAction private func onGoButton(_ sender: Any) {
        if passwordTextField.text == password {
            let viewController = ShowAddedPicturesVC.instantiate()
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showAlertWithOneButton(title: "Wrong password", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
        }
    }
}

extension PasswordVerificationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
