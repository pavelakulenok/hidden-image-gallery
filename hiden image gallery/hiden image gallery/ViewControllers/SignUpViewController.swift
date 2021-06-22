//
//  PasswordVerificationVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let isNotFirstLaunch = UserDefaults.standard.bool(forKey: "isNotFirstLaunch")
        let onAutoLogin = UserDefaults.standard.bool(forKey: "onAutoLogin")
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        if isNotFirstLaunch {
            if onAutoLogin && isUserLoggedIn {
                let viewController = GalleryViewController.instantiate()
                navigationController?.pushViewController(viewController, animated: false)
            } else if !onAutoLogin || !isUserLoggedIn {
                let viewController = LogInViewController.instantiate()
                navigationController?.pushViewController(viewController, animated: false)
            }
        }

        title = "Sign up"
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        setupUI()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @IBAction private func onSignUpButton(_ sender: Any) {
        if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            if password != confirmPassword {
                showAlertWithOneButton(title: "passwords is not equal", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else if password.isEmpty {
                showAlertWithOneButton(title: "password field is empty", message: "enter your password", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else {
                let viewController = GalleryViewController.instantiate()
                navigationController?.pushViewController(viewController, animated: true)
                if segmentedControl.selectedSegmentIndex == 0 {
                    UserDefaults.standard.setValue(true, forKey: "onAutoLogin")
                }
                UserDefaults.standard.setValue(true, forKey: "isNotFirstLaunch")
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
        signUpButton.applyCornerRadius(15)
        signUpButton.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
        passwordView.applyCornerRadius(25)
        passwordView.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
        passwordTextField.applyCornerRadius(15)
        confirmPasswordTextField.applyCornerRadius(15)

        if let font = UIFont(name: "Verdana Bold", size: 15) {
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        segmentedControl.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
