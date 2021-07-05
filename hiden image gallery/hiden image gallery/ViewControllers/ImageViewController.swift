//
//  ImageViewController.swift
//  hiden image gallery
//
//  Created by Pavel Akulenak on 16.06.21.
//

import UIKit

class ImageViewController: UIViewController {
    var filePath: String?

    let imageView = UIImageView()
    let imageScrollView = UIScrollView()
    let scrollView = UIScrollView()
    let commentLabel = UILabel()
    let commentTextField = UITextField()
    let addCommentButton = UIButton()

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        self.view = view
        view.addSubview(scrollView)
        scrollView.addSubview(commentLabel)
        scrollView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageView)
        scrollView.addSubview(commentTextField)
        scrollView.addSubview(addCommentButton)
        setupUI()
        configureNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        commentTextField.delegate = self
        imageScrollView.maximumZoomScale = 3
        imageView.contentMode = .scaleAspectFit
        addCommentButton.addTarget(self, action: #selector(onAddCommentButton), for: .touchUpInside)
        commentTextField.textAlignment = .center
        commentTextField.autocorrectionType = .no
        commentLabel.textAlignment = .center

        if let path = filePath {
            imageView.image = UIImage(contentsOfFile: path)
            let url = URL(fileURLWithPath: path)
            let name = url.lastPathComponent
            commentLabel.text = UserDefaults.standard.string(forKey: name)
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets.bottom + view.safeAreaInsets.top
        let commentViewsHeight: CGFloat = 50
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height - safeAreaInsets)
        commentLabel.frame = CGRect(x: 10, y: 0, width: scrollView.frame.width - 20, height: commentViewsHeight)
        imageScrollView.frame = CGRect(x: 0, y: commentLabel.frame.maxY, width: scrollView.frame.width, height: view.bounds.height - safeAreaInsets - commentViewsHeight * 2)
        imageView.frame = imageScrollView.bounds
        commentTextField.frame = CGRect(x: 10, y: scrollView.frame.height - safeAreaInsets - commentViewsHeight, width: scrollView.frame.width - 125, height: commentViewsHeight)
        imageScrollView.contentSize = CGSize(width: imageView.frame.width, height: imageView.frame.height)
        addCommentButton.frame = CGRect(x: scrollView.frame.width - 105, y: scrollView.frame.height - safeAreaInsets - commentViewsHeight, width: 100, height: commentViewsHeight)
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

    @objc private func onDeleteImageButton() {
        showAlertWithTwoButtons(title: "Delete this image?", message: "select action", firstActionTitle: "Delete", firstActionStyle: .destructive, firstHandler: { _ in
            if let path = self.filePath {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    assertionFailure("can't delete file from \(path)")
                }
            }
            let viewController = GalleryViewController.instantiate()
            self.navigationController?.pushViewController(viewController, animated: true)
        }, secondActionTitle: "Cancel", secondActionStyle: .default, secondHandler: nil)
    }

    @objc private func onAddCommentButton() {
        if let commentString = commentTextField.text, let path = filePath {
            let url = URL(fileURLWithPath: path)
            let name = url.lastPathComponent
            if !commentString.isEmpty {
                commentLabel.text = commentString
                UserDefaults.standard.setValue(commentString, forKey: name)
            }
        }
        commentTextField.resignFirstResponder()
    }

    private func configureNavBar() {
        title = "Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeleteImageButton))
        navigationController?.navigationBar.tintColor = .label
    }

    private func setupUI() {
        commentLabel.applyCornerRadius(10)
        commentTextField.applyCornerRadius(10)
        commentLabel.addBorderWidth(1)
        commentLabel.backgroundColor = .secondarySystemBackground
        commentTextField.addBorderWidth(1)
        commentTextField.backgroundColor = .secondarySystemBackground
        commentLabel.font = UIFont(name: "Verdana", size: 17)
        commentTextField.font = UIFont(name: "Verdana", size: 17)
        addCommentButton.setTitle("Comment", for: .normal)
        addCommentButton.setTitleColor(.label, for: .normal)
        addCommentButton.titleLabel?.font = UIFont(name: "Verdana Bold", size: 17)
        addCommentButton.addBorderWidth(1)
        addCommentButton.backgroundColor = .secondarySystemBackground
        addCommentButton.applyCornerRadius(10)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
