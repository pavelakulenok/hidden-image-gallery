//
//  ViewController.swift
//  Homework18.1
//
//  Created by Pavel Akulenak on 26.04.21.
//

import UIKit

class ViewController: UIViewController {
    private var customView = UIView()
    private var infoView = UIView()
    private var isInfoShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = Bundle.main.loadNibNamed("MyCustomView", owner: self, options: nil)?.first as? UIView {
            customView = view
        }
        customView.frame = view.bounds
        view.addSubview(customView)
    }

    @IBAction private func onButton(_ sender: Any) {
        if !isInfoShown {
            if let view = Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)?.first as? UIView {
                infoView = view
            }
            let x = (view.frame.width - infoView.frame.width) / 2
            let y = (view.frame.height - infoView.frame.height) / 2
            infoView.frame = CGRect(x: x, y: y, width: infoView.frame.width, height: infoView.frame.height)
            infoView.layer.cornerRadius = 30
            customView.addSubview(infoView)
            isInfoShown = true
        }
    }

    @IBAction private func onOkButton(_ sender: Any) {
        infoView.removeFromSuperview()
        isInfoShown = false
    }
}
