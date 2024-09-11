//
//  MenuViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var categoriesButtonArray: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesButtonArray.forEach({ $0.titleLabel?.font = .semibold(size: 24) })
    }
    
    @IBAction func clickedClasses(_ sender: UIButton) {
    }
    
    @IBAction func clickedNotes(_ sender: UIButton) {
    }

    @IBAction func clickedFacts(_ sender: UIButton) {
    }
}
