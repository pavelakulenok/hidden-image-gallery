//
//  ImageCollectionViewCell.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 21.05.21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!

    @IBAction private func onAddCommentButton(_ sender: UIButton) {
        if let commentString = commentTextField.text {
            if !commentString.isEmpty {
                commentLabel.text = commentString
                let imagesArray = ReadFromDirectoryManager.getImagesNameArray()
                UserDefaults.standard.setValue(commentString, forKey: imagesArray[sender.tag])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.applyCornerRadius()
        contentView.borderWidth(3)
        commentLabel.borderWidth(2)
        commentTextField.borderWidth(2)
        addCommentButton.borderWidth(2)
        addCommentButton.applyCornerRadius()
        commentTextField.applyCornerRadius()
    }
}
