//
//  ShowAddedPicturesVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class ShowAddedPicturesVC: UIViewController {
    private let insetSize: CGFloat = 10
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(onMenuButton))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main
        ), forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
    }

    @objc func onMenuButton() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset = .zero
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
}

extension ShowAddedPicturesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ShowAddedPicturesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 2 * insetSize)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReadFromDirectoryManager.getImagesNameArray().count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetSize, left: 0, bottom: insetSize, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let fileName = ReadFromDirectoryManager.getImagesNameArray()[indexPath.item]
        let filePath = ReadFromDirectoryManager.getImagePath(item: indexPath.item)
        cell.imageView.image = UIImage(contentsOfFile: filePath)
        cell.commentLabel.text = UserDefaults.standard.string(forKey: fileName)
        cell.commentTextField.delegate = self
        cell.applyCornerRadius()
        cell.borderWidth(3)
        cell.addCommentButton.tag = indexPath.item
        cell.commentTextField.text = nil
        return cell
    }
}
