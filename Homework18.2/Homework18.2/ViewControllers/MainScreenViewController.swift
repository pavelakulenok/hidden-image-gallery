//
//  ViewController.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 25.04.21.
//

import UIKit

class MainScreenViewController: UIViewController {
    private var imagesFolderURL: URL?

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var showPhotosButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoButton.applyCornerRadius()
        showPhotosButton.applyCornerRadius()
        imagesFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    @IBAction private func onAddPhotoButton(_ sender: Any) {
        displayImagePickerController()
    }

    @IBAction private func onShowAddedPhotosButton(_ sender: Any) {
        if ReadFromDirectoryManager.getImagesNameArray().isEmpty {
            showAlertWithOneButton(title: "No images to show", message: "Add images", actionTitle: "OK", actionStyle: .default, handler: nil)
        } else {
            let viewController = PasswordVerificationVC.instantiate()
            navigationController?.pushViewController(viewController, animated: true)
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
            let imagePath = imagesFolderURL?.appendingPathComponent(name)
            if let path = imagePath {
                FileManager.default.createFile(atPath: path.path, contents: imageData, attributes: nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
