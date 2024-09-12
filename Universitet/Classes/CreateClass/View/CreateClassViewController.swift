//
//  CreateClassViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit
import Combine

class CreateClassViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var classesTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var noteTextView: BaseTextView!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var poorButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var createBGView: UIView!
    @IBOutlet weak var notesTopConst: NSLayoutConstraint!
    @IBOutlet weak var notesTopToLineConst: NSLayoutConstraint!
    @IBOutlet weak var addBUtton: UIButton!
    @IBOutlet weak var noteHeightConst: NSLayoutConstraint!
    @IBOutlet weak var notesLabel: UILabel!
    var completion: (() -> ())?
    private let viewModel = CreateClassViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    private var selectedMood: UIButton? {
        didSet {
            if oldValue != selectedMood {
                selectedMood?.layer.borderColor = UIColor.black.cgColor
                selectedMood?.layer.borderWidth = 3
                oldValue?.layer.borderColor = UIColor.background.cgColor
                oldValue?.layer.borderWidth = 2
            }
        }
    }
    private var selectedStudyingDay: UIButton? {
        didSet {
            if oldValue != selectedStudyingDay {
                selectedStudyingDay?.backgroundColor = .background
                oldValue?.backgroundColor = .black.withAlphaComponent(0.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func updatePreferredContentSize() {
        let fittingSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = CGSize(width: view.bounds.width, height: fittingSize.height)
    }
    
    func setupUI() {
        yesButton.titleLabel?.font = .medium(size: 18)
        noButton.titleLabel?.font = .medium(size: 18)
        goodButton.titleLabel?.font = .medium(size: 16)
        mediumButton.titleLabel?.font = .medium(size: 16)
        poorButton.titleLabel?.font = .medium(size: 16)
        createButton.titleLabel?.font = .medium(size: 14)
        noteTextView.baseDelegate = self
        noteTextView.placeholder = "Notes"
        let buttons = [goodButton, mediumButton, poorButton]
        buttons.forEach({ $0?.layer.borderWidth = 2; $0?.layer.borderColor = UIColor.background.cgColor})
        classesTableView.delegate = self
        classesTableView.dataSource = self
        classesTableView.register(UINib(nibName: "ClassesTableViewCell", bundle: nil), forCellReuseIdentifier: "ClassesTableViewCell")
        classesTableView.register(UINib(nibName: "DayNameTableViewCell", bundle: nil), forCellReuseIdentifier: "DayNameTableViewCell")
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        self.classesTableView.reloadData()
        self.classesTableView.layoutIfNeeded()
        self.tableViewHeightConst.constant = self.classesTableView.contentSize.height
        updatePreferredContentSize()
    }
    
    func updateUI() {
        notesTopConst.isActive = viewModel.isActiveDay
        notesTopToLineConst.constant = 24
        notesTopToLineConst.isActive = !viewModel.isActiveDay
        addBUtton.isHidden = !viewModel.isActiveDay
        classesTableView.isHidden = !viewModel.isActiveDay
        noteHeightConst.constant = viewModel.isActiveDay ? 56 : 120
        notesLabel.text = viewModel.isActiveDay ? "Mini notes" : "Notes"
    }
    
    func subscribe() {
        viewModel.$classes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] classes in
                guard let self = self else { return }
                if classes.count != self.viewModel.previousClassesCount {
                    self.classesTableView.reloadData()
                    self.classesTableView.layoutIfNeeded()
                    self.tableViewHeightConst.constant = self.classesTableView.contentSize.height
                    self.viewModel.previousClassesCount = classes.count
                }
            }
            .store(in: &cancellables)
        
        viewModel.$mood
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mood in
                guard let self = self else { return }
                self.updateSelectedMood()
            }
            .store(in: &cancellables)
        
        viewModel.$isActiveDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActiveDay in
                guard let self = self else { return }
                self.selectedStudyingDay = isActiveDay ? yesButton : noButton
                self.updateUI()
            }
            .store(in: &cancellables)

        viewModel.$isValidate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValidate in
                guard let self = self else { return }
                self.createButton.isEnabled = isValidate
                self.createBGView.isHidden = isValidate
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedMood() {
        switch viewModel.mood {
        case .good:
            selectedMood = goodButton
        case .medium:
            selectedMood = mediumButton
        case .poor:
            selectedMood = poorButton
        case .none:
            break
        }
    }

    @IBAction func clickedAddClasses(_ sender: UIButton) {
        viewModel.addClasses()
    }
    
    @IBAction func chooseStudyingDay(_ sender: UIButton) {
        viewModel.changeStudyingDay(isStudying: (sender == yesButton))
    }
    
    @IBAction func chooseMood(_ sender: UIButton) {
        if let mood = Mood(rawValue: sender.tag) {
            viewModel.changeMood(mood: mood)
        }
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: completion)
    }
    
    @IBAction func clickedCreate(_ sender: UIButton) {
        if viewModel.createClasses() {
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension CreateClassViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isActiveDay ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.classes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayNameTableViewCell", for: indexPath) as! DayNameTableViewCell
            cell.setupContent(name: viewModel.dayModel?.dayName)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesTableViewCell", for: indexPath) as! ClassesTableViewCell
            cell.setupContent(model: viewModel.classes[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            let footerView = UIView()
            let addButton = UIButton(type: .custom)
            addButton.setImage(UIImage(named: "Add"), for: .normal)
            addButton.frame = CGRect(x: 0, y: 20, width: 36, height: 36)
            addButton.layer.cornerRadius = 18
            addButton.backgroundColor = .background
            footerView.addSubview(addButton)
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .medium(size: 18)
        label.textColor = .background
        label.text = section == 0 ? "Come up with a name for the day" : "Classes"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CreateClassViewController: ClassesTableViewCellDelegate {
    func changeClassName(name: String?, index: Int) {
        viewModel.changeClassName(name: name, _at: index)

    }
    
    func changeDate(date: String?, index: Int) {
        viewModel.changeClassDate(date: date, _at: index)
    }
}

extension CreateClassViewController: DayNameTableViewCellDelegate {
    func changeName(name: String?) {
        viewModel.changeDayName(name: name)
    }
}

extension CreateClassViewController: BaseTextViewDelegate {
    func didChancheSelection(_ textView: UITextView) {
        viewModel.changeNote(note: textView.text)
    }
}

extension CreateClassViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateClassViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
