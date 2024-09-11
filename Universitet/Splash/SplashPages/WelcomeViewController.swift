//
//  WelcomeViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .bold(size: 32)
        descriptionLabel.font = .bold(size: 24)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
            self.navigationController?.viewControllers = [menuVC]
        }
    }
}
