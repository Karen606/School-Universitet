//
//  DayNameTableViewCell.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

protocol DayNameTableViewCellDelegate: AnyObject {
    func changeName(name: String?)
}

class DayNameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: BaseTextField!
    weak var delegate: DayNameTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupContent(name: String?) {
        self.nameTextField.text = name
    }
    
    func setupContentForRead(name: String?) {
        self.nameTextField.text = name
        self.nameTextField.isEnabled = false
    }
}

extension DayNameTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.changeName(name: textField.text)
    }
}
