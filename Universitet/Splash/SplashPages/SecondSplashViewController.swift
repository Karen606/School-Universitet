//
//  SecondSplashViewController.swift
//  Freelancer's Diary
//
//  Created by Karen Khachatryan on 27.08.24.
//

import UIKit

class SecondSplashViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .semibold(size: 24)
        descriptionlabel.font = .semibold(size: 18)
    }
}
