//
//  FirstSplashViewController.swift
//  Freelancer's Diary
//
//  Created by Karen Khachatryan on 27.08.24.
//

import UIKit

class FirstSplashViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .semibold(size: 24)
        descriptionLabel.font = .semibold(size: 18)
    }
}
