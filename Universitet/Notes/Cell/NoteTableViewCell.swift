//
//  NoteTableViewCell.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        noteButton.titleLabel?.font = .semibold(size: 18)
        noteButton.setTitleColor(.black, for: .normal)
        dateLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func formatDate(date: Date) -> NSAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM."
        let formattedDate = formatter.string(from: date)
        let dateComponents = formattedDate.split(separator: " ")
        let dayNumber = String(dateComponents[0])
        let month = String(dateComponents[1])
        let dayNumberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semibold(size: 32) as Any,
            .foregroundColor: UIColor.white
        ]
        let attributedDayNumber = NSAttributedString(string: dayNumber, attributes: dayNumberAttributes)
        let monthAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semibold(size: 12) as Any,
            .foregroundColor: UIColor.white.withAlphaComponent(0.5)
        ]
        let attributedMonth = NSAttributedString(string: " " + month, attributes: monthAttributes)
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(attributedDayNumber)
        finalAttributedString.append(attributedMonth)
        return finalAttributedString
    }
    
    func dateFormatWeekday(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayOfWeek = formatter.string(from: date)
        return dayOfWeek.uppercased()
    }
    
    func setupContent(date: Date) {
        self.dateLabel.attributedText = formatDate(date: date)
        self.noteButton.setTitle(dateFormatWeekday(date: date), for: .normal)
    }
    
    @IBAction func chooseNote(_ sender: UIButton) {
    }
}
