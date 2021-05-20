//
//  PasswordVerificationVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class PasswordVerificationVC: UIViewController {
    private let password = "123"

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.applyCornerRadius(backButton.frame.width / 2)
        goButton.applyCornerRadius(goButton.frame.width / 2)
        passwordTextField.delegate = self
    }

    @IBAction private func onGoButton(_ sender: Any) {
        if passwordTextField.text == password {
            let viewController = ShowAddedPicturesVC.instantiate()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        } else {
            showAlertWithOneButton(title: "Wrong password", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
        }
    }

    @IBAction private func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PasswordVerificationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
