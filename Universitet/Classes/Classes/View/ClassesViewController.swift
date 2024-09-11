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
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        todayEventView.roundCorners([.topLeft, .topRight], radius: 24)

    }
    
    func setupUI() {
        calendar.appearance.selectionColor = #colorLiteral(red: 0.7720025182, green: 0.2696399093, blue: 0.2442657351, alpha: 1)
        calendar.appearance.titleSelectionColor = .white
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
                self?.todayEventView.isHidden = days.contains(where: { $0.date == Date.currentDay() })
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
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
            return #colorLiteral(red: 0.7720025182, green: 0.2696399093, blue: 0.2442657351, alpha: 1)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
}
