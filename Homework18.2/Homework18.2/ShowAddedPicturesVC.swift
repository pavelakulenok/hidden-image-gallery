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
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @IBAction private func onBack(_ sender: Any) {
        let imageViewAnimateX = view.frame.maxX
        let imageViewCompletionX = -imageView.frame.width

        if let array = imagesNameArray {
            if indexOfImage < array.count - 1 {
                indexOfImage += 1
            } else {
                indexOfImage = 0
            }
        }
        animatedImagePaging(animateX: imageViewAnimateX, completionX: imageViewCompletionX)
    }

    @IBAction private func onNext(_ sender: Any) {
        let imageViewAnimateX = view.frame.minX - imageView.frame.height
        let imageViewCompletionX = view.frame.maxX

        if let array = imagesNameArray {
            if indexOfImage > 0 {
                indexOfImage -= 1
            } else {
                indexOfImage = array.count - 1
            }
        }
        animatedImagePaging(animateX: imageViewAnimateX, completionX: imageViewCompletionX)
    }

    private func animatedImagePaging(animateX: CGFloat, completionX: CGFloat) {
        let x = imageView.frame.minX
        let y = imageView.frame.minY
        let width = imageView.frame.width
        let height = imageView.frame.height

        UIView.animate(withDuration: 0.15) {
            self.imageView.frame = CGRect(x: animateX, y: y, width: width, height: height)
            self.imageView.alpha = 0
        } completion: { _ in
            self.imageView.frame = CGRect(x: completionX, y: y, width: width, height: height)
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame = CGRect(x: x, y: y, width: width, height: height)
                if let array = self.imagesNameArray {
                    let fileName = array[self.indexOfImage]
                    if let filePath = self.imagesFolderPath?.appendingPathComponent(fileName).path {
                        self.imageView.image = UIImage(contentsOfFile: filePath)
                    }
                }
                self.imageView.alpha = 1
            }
        }
    }
}
