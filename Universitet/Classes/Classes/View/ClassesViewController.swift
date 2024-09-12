//
//  ClassesViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit
import FSCalendar
import Combine

class ClassesViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todayEventView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = ClassesViewModel.shared
    var dates: [Date] = [] {
        didSet {
            calendar.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(title: "Classes")
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        todayEventView.roundCorners([.topLeft, .topRight], radius: 24)

    }
    
    func setupUI() {
        calendar.appearance.selectionColor = #colorLiteral(red: 0.7720025182, green: 0.2696399093, blue: 0.2442657351, alpha: 1)
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.titleFont = .medium(size: 14)
        calendar.delegate = self
        calendar.dataSource = self
        backButton.titleLabel?.font = .medium(size: 14)
        descriptionLabel.font = .medium(size: 18)
    }
    
    func subscribe() {
        viewModel.$days
            .receive(on: DispatchQueue.main)
            .sink { [weak self] days in
                self?.calendar.reloadData()
                if let selectedDate = self?.calendar.selectedDate {
                    self?.todayEventView.isHidden = days.contains(where: { $0.date == selectedDate })
                } else {
                    self?.todayEventView.isHidden = true
                }
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
    }
    
    func showDayInfo(dayModel: DayModel) {
        let dayInfoVC = DayInfoViewController(nibName: "DayInfoViewController", bundle: nil)
        dayInfoVC.modalPresentationStyle = .custom
        dayInfoVC.transitioningDelegate = self
        dayInfoVC.dayModel = dayModel
        dayInfoVC.compeltion = { [weak self] in
            guard let self = self else { return }
            calendar.deselect(dayModel.date)
        }
        self.present(dayInfoVC, animated: true)
    }
    
    @IBAction func createDay(_ sender: UIButton) {
        let createClassesVC = CreateClassViewController(nibName: "CreateClassViewController", bundle: nil)
        createClassesVC.modalPresentationStyle = .custom
        createClassesVC.transitioningDelegate = self
        CreateClassViewModel.shared.date = calendar.selectedDate
        createClassesVC.completion = { [weak self] in
            guard let self = self else { return }
            if let selectedDate = self.calendar.selectedDate {
                calendar.deselect(selectedDate)
            }
            calendar.isHidden = false
            self.viewModel.getDays()
            CreateClassViewModel.shared.clear()
        }
        createClassesVC.handleClose = { [weak self] in
            guard let self = self else { return }
            calendar.isHidden = false
            CreateClassViewModel.shared.clear()
        }
        self.present(createClassesVC, animated: true)
        calendar.isHidden = true
    }
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        }
    }
}

extension ClassesViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if viewModel.days.contains(where: {$0.isActiveDay && $0.date == date }) {
            return .background
        } else if viewModel.days.contains(where: {!$0.isActiveDay && $0.date == date }) {
            return .clear
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if viewModel.days.contains(where: {$0.isActiveDay && $0.date == date }) {
            return .white
        } else if viewModel.days.contains(where: {!$0.isActiveDay && $0.date == date }) {
            return #colorLiteral(red: 0.7921568627, green: 0, blue: 0, alpha: 1)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let dayModel = viewModel.days.first(where: { $0.date == date }) {
            self.todayEventView.isHidden = true
            showDayInfo(dayModel: dayModel)
        } else {
            self.todayEventView.isHidden = false
        }
    }
}

extension ClassesViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presented {
        case is CreateClassViewController:
            let todayEventPresentationController = TodayEventPresentationController(presentedViewController: presented, presenting: presenting)
            return todayEventPresentationController
        case is DayInfoViewController:
            let todayEventPresentationController = TodayEventPresentationController(presentedViewController: presented, presenting: presenting)
            return todayEventPresentationController
        default:
            return nil
        }
    }
}

extension UIViewController {
    func setNavigationBar(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .semibold(size: 24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}
