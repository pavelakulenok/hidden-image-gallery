//
//  ViewController.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 25.04.21.
//

import UIKit

class MainScreenViewController: UIViewController {
    private var imagesFolderPath: URL?
    private var imagesNameArray: [String]?

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var showPhotosButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoButton.applyCornerRadius()
        showPhotosButton.applyCornerRadius()
        imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    @IBAction private func onAddPhotoButton(_ sender: Any) {
        displayImagePickerController()
    }

    @IBAction private func onShowAddedPhotosButton(_ sender: Any) {
        guard let path = imagesFolderPath?.path else {
            showAlertWithOneButton(title: "Error", message: "Can't find directory", actionTitle: "Ok", actionStyle: .default, handler: nil)
            return
        }
        do {
            imagesNameArray = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            showAlertWithOneButton(title: "Error", message: "Can't read from directory", actionTitle: "Ok", actionStyle: .default, handler: nil)
        }

        if let array = imagesNameArray {
            if array.isEmpty {
                showAlertWithOneButton(title: "No images to show", message: "Add images", actionTitle: "OK", actionStyle: .default, handler: nil)
            } else {
                let viewController = PasswordVerificationVC.instantiate()
                present(viewController, animated: true, completion: nil)
            }
        }
    }

    private func displayImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension MainScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            let path = info[.imageURL] as? URL
            guard let name = path?.lastPathComponent else {
                return
            }
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imagePath = imagesFolderPath?.appendingPathComponent(name)
            if let path = imagePath {
                FileManager.default.createFile(atPath: path.path, contents: imageData, attributes: nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
