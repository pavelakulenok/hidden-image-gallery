//
//  ShowAddedPicturesVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class ShowAddedPicturesVC: UIViewController {
    private var imagesNameArray: [String]?
    private var imagesFolderPath: URL?
    private var indexOfImage = 0
    private var commentsToImages: [String: String]?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var previousImageButton: UIButton!
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextField.delegate = self
        addCommentButton.layer.cornerRadius = 10
        backToMenuButton.layer.cornerRadius = 20
        previousImageButton.layer.cornerRadius = 20
        nextImageButton.layer.cornerRadius = 20
        imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let path = imagesFolderPath?.path else {
            return
        }
        imagesNameArray = try? FileManager.default.contentsOfDirectory(atPath: path)
        if let array = imagesNameArray {
            let fileName = array[indexOfImage]
            if let filePath = imagesFolderPath?.appendingPathComponent(fileName).path {
                imageView.image = UIImage(contentsOfFile: filePath)
            }
        }
        showCommentToImage()
    }

    @IBAction private func onAddCommentButton(_ sender: Any) {
        commentsLabel.text = commentsTextField.text
        setCommentToImage()
    }

    @IBAction private func onBackToMenuButton(_ sender: Any) {
        let viewController = MainScreenViewController.instantiate()
        present(viewController, animated: true, completion: nil)
    }

    @IBAction private func onPreviousImageButton(_ sender: Any) {
        if let array = imagesNameArray {
            if indexOfImage < array.count - 1 {
                indexOfImage += 1
            } else {
                indexOfImage = 0
            }
        }
        animatedImagePaging()
        showCommentToImage()
        commentsTextField.text = nil
    }

    @IBAction private func onNextImageButton(_ sender: Any) {
        if let array = imagesNameArray {
            if indexOfImage > 0 {
                indexOfImage -= 1
            } else {
                indexOfImage = array.count - 1
            }
        }
        animatedImagePaging()
        showCommentToImage()
        commentsTextField.text = nil
    }

    private func animatedImagePaging() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                if let array = self.imagesNameArray {
                    let fileName = array[self.indexOfImage]
                    if let filePath = self.imagesFolderPath?.appendingPathComponent(fileName).path {
                        self.imageView.image = UIImage(contentsOfFile: filePath)
                    }
                }
                self.contentView.alpha = 1
            }
        }
    }

    private func setCommentToImage() {
        if let nameOfImage = imagesNameArray?[indexOfImage] {
            UserDefaults.standard.setValue(commentsLabel.text, forKey: nameOfImage)
        }
    }

    private func showCommentToImage() {
        if let nameOfImage = imagesNameArray?[indexOfImage] {
            commentsLabel.text = UserDefaults.standard.string(forKey: nameOfImage)
        }
    }
}

extension ShowAddedPicturesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
