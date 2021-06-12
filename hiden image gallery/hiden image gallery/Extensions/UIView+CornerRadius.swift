//
//  UIView+CornerRadius.swift
//  Racing
//
//  Created by Pavel Akulenak on 20.05.21.
//

import UIKit

extension UIView {
    func applyCornerRadius(_ radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
}
