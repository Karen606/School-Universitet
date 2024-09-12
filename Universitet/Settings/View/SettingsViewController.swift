//
//  SettingsViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var settingButton: [UIButton]!
    @IBOutlet var sectionViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        sectionViews.forEach { view in
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 4
            view.layer.cornerRadius = 18
        }
        settingButton.forEach({ $0.titleLabel?.font = .semibold(size: 22) })
    }

    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        }
    }
}
