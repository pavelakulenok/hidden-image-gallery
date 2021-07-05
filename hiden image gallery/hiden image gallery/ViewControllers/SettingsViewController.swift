//
//  ViewController.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 25.04.21.
//

import KeychainAccess
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        let onAutoLogin = UserDefaults.standard.bool(forKey: "onAutoLogin")
        if onAutoLogin {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }

        setupUI()

        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(onLogOutButton))
        navigationController?.navigationBar.tintColor = .label
    }

    @IBAction private func segmentedControlValueChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            UserDefaults.standard.setValue(true, forKey: "onAutoLogin")
        } else {
            UserDefaults.standard.setValue(false, forKey: "onAutoLogin")
        }
    }

    @IBAction private func onChangePasswordButton(_ sender: Any) {
        if let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            let keychain = Keychain()
            if oldPassword != keychain["hidenImageGalleryPassword"] {
                showAlertWithOneButton(title: "Wrong password", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else if newPassword.isEmpty {
                showAlertWithOneButton(title: "New password field is empty", message: "enter your password", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else if confirmPassword.isEmpty {
                showAlertWithOneButton(title: "Confirm password field is empty", message: "enter your password", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else if newPassword != confirmPassword {
                showAlertWithOneButton(title: "passwords is not equal", message: "please try again", actionTitle: "Ok", actionStyle: .default, handler: nil)
            } else {
                keychain["hidenImageGalleryPassword"] = nil
                keychain["hidenImageGalleryPassword"] = newPassword
                let viewController = GalleryViewController.instantiate()
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    @objc private func onLogOutButton() {
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
        let viewController = LogInViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
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
        changePasswordButton.applyCornerRadius(15)
        changePasswordButton.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
        changePasswordView.applyCornerRadius(25)
        changePasswordView.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
        oldPasswordTextField.applyCornerRadius(15)
        newPasswordTextField.applyCornerRadius(15)
        confirmPasswordTextField.applyCornerRadius(15)
        if let font = UIFont(name: "Verdana Bold", size: 15) {
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        segmentedControl.addShadow(color: .black, opacity: 1, offSet: .zero, radius: 10)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
