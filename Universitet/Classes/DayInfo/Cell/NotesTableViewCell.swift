//
//  NotesTableViewCell.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextView: BaseTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextView.font = .medium(size: 18)
        noteTextView.textColor = .black
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupContent(note: String?) {
        noteTextView.text = note
    }
    
}
