//
//  ViewController.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 25.04.21.
//

import UIKit

class ViewController: UIViewController {
    private var imageArray = [UIImage]()

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var showPhotosButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoButton.layer.cornerRadius = 20
        showPhotosButton.layer.cornerRadius = 20
    }

    @IBAction private func onAddPhotoButton(_ sender: Any) {
        displayImagePickerController()
    }

    private func displayImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
        imageArray.append(image)
        }
        dismiss(animated: true, completion: nil)
    }
}
