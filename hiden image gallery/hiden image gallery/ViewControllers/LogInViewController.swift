//
//  LogInViewController.swift
//  hiden image gallery
//
//  Created by Pavel Akulenak on 16.06.21.
//

import UIKit

class LogInViewController: UIViewController {
    let userPassword = "123"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        setupUI()
        navigationItem.hidesBackButton = true
        passwordTextField.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @IBAction private func onLoginButton(_ sender: Any) {
        if let password = passwordTextField.text {
            if password == userPassword {
                UserDefaults.standard.setValue(true, forKey: "userLoggedIn")
                let viewController = GalleryViewController.instantiate()
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                showAlertWithOneButton(title: "Wrong password", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
            }
        }
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func setupUI() {
        passwordView.applyCornerRadius(25)
        passwordTextField.applyCornerRadius(15)
        loginButton.applyCornerRadius(15)
        passwordView.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
        loginButton.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
