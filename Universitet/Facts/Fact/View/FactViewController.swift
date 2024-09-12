//
//  FactViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class FactViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var factModel: FactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.background]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.background]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black, // Set text color to red
            .font: UIFont.semibold(size: 24) as Any // Set custom font
            ]
        navigationController?.navigationBar.tintColor = .background
        navigationController?.navigationBar.standardAppearance = appearance
        //        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        titleLabel.font = .bold(size: 18)
        self.title = "Facts"
        descriptionTextView.font = .medium(size: 18)
        if let factModel = factModel {
            titleLabel.text = factModel.title
            descriptionTextView.text = factModel.description
            logoImageView.image = UIImage(named: factModel.image)
        }
    }

}
