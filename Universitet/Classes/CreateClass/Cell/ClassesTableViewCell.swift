//
//  ClassesTableViewCell.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

protocol ClassesTableViewCellDelegate: AnyObject {
    func changeClassName(name: String?, index: Int)
    func changeDate(date: String?, index: Int)
}

class ClassesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    private var hourPicker = UIDatePicker()
    weak var delegate: ClassesTableViewCellDelegate?
    private var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        dateTextField.delegate = self
        dateTextField.inputView = hourPicker
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupContent(model: Classes, index: Int) {
        self.index = index
        self.nameTextField.text = model.name
        self.dateTextField.text = model.date
        hourPicker.locale = NSLocale.current
        hourPicker.datePickerMode = .time
        hourPicker.preferredDatePickerStyle = .wheels
        hourPicker.addTarget(self, action: #selector(hourPickerValueChanged(sender:)), for: .valueChanged)
        hourPicker.tintColor = UIColor(named: "CustomRed")
    }
    
    func setupContentForRead(model: Classes?, index: Int) {
        self.backgroundColor = .clear
        self.nameTextField.text = model?.name
        self.dateTextField.text = model?.date
        self.nameTextField.isEnabled = false
        self.dateTextField.isEnabled = false
    }
    
    @objc func hourPickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "HH:mm"
        let formatedDate = hourFormmater.string(from: hourDate)
        dateTextField.text = formatedDate
        delegate?.changeDate(date: formatedDate, index: index)
    }
}

extension ClassesTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            delegate?.changeClassName(name: textField.text, index: index)
        case dateTextField:
            delegate?.changeDate(date: textField.text, index: index)
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == dateTextField ? false : true
    }
}

