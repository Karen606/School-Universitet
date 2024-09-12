//
//  FactTableViewCell.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class FactTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .bold(size: 18)
        logoImageView.layer.masksToBounds = true
        arrowImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupContent(fact: FactModel) {
        titleLabel.text = fact.title
        logoImageView.image = UIImage(named: fact.image)
    }
    
}
