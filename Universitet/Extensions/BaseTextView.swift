//
//  BaseTextView.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

protocol BaseTextViewDelegate: AnyObject {
    func didChancheSelection(_ textView: UITextView)
}

class BaseTextView: UITextView {
    
    private var customPadding = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 14)
    weak var baseDelegate: BaseTextViewDelegate?
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.25)
        label.font = .medium(size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    override var text: String! {
        didSet {
            togglePlaceholderVisibility()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = customPadding
        self.backgroundColor = .background.withAlphaComponent(0.25)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.background.cgColor
        self.layer.cornerRadius = 12
        placeholderLabel.frame.origin = CGPoint(x: customPadding.left + 5, y: customPadding.top)
        placeholderLabel.frame.size.width = frame.width - (customPadding.left + customPadding.right + 10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlaceholder()
        self.delegate = self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.isHidden = !text.isEmpty
        togglePlaceholderVisibility()
    }
    
    private func togglePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

extension BaseTextView: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        baseDelegate?.didChancheSelection(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholderVisibility()
    }
}
