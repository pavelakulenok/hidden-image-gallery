//
//  ShowAddedPicturesVC.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 1.05.21.
//

import UIKit

class GalleryViewController: UIViewController {
    private let insetSize: CGFloat = 2
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main
        ), forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
    }

    @objc private func onAddButton() {
        displayImagePickerController()
    }

    @objc private func onUserButton() {
        let viewController = SettingsViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func displayImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    private func configureNavBar() {
        title = "Gallery"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(onUserButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButton))
        navigationController?.navigationBar.tintColor = .label
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 2 * insetSize) / 3, height: (collectionView.frame.width - 2 * insetSize) / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetSize
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReadFromDirectoryManager.getImagesNameArray().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let filePath = ReadFromDirectoryManager.getImagePath(item: indexPath.item)
        cell.imageView.image = UIImage(contentsOfFile: filePath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ImageViewController.instantiate()
        let filePath = ReadFromDirectoryManager.getImagePath(item: indexPath.item)
        viewController.filePath = filePath
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            let path = info[.imageURL] as? URL
            guard let name = path?.lastPathComponent else {
                assertionFailure("can't get name of image from image path")
                return
            }
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imagesFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let imagePath = imagesFolderURL?.appendingPathComponent(name)
            if let path = imagePath {
                FileManager.default.createFile(atPath: path.path, contents: imageData, attributes: nil)
            }
        }
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
