//
//  NoteDropDownView.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class NoteDropDownView: UIView {

    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var noteTextView: BaseTextView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodButton: UIButton!
   
    @IBOutlet weak var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func commonInit(note: String) {
        notesLabel.font = .medium(size: 18)
        moodLabel.font = .medium(size: 18)
        moodButton.titleLabel?.font = .medium(size: 16)
        moodButton.layer.borderWidth = 3
        moodButton.layer.borderColor = UIColor.background.cgColor
        moodButton.layer.cornerRadius = 12
        noteTextView.text = note
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

    }
  
    class func instanceFromNib() -> NoteDropDownView {
        return UINib(nibName: "NoteDropDownView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoteDropDownView
    }
}
