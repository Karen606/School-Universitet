//
//  NotesViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit
import Combine

class NotesViewController: UIViewController {
    @IBOutlet weak var notesTableView: UITableView!
    private let viewModel = NotesViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var dropdownView: UIView?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(title: "Notes")
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
    }
    
    func subscribe() {
        viewModel.$activeDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] activeDates in
                self?.notesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func showDropDown(below cell: UITableViewCell?, in tableView: UITableView, index: Int) {
        guard let cell = cell else { return }
        let cellFrameInTableView = tableView.convert(cell.frame, to: tableView)
        var dropdownOriginY = cellFrameInTableView.maxY
        
        let dropdown = createDropDownView()
        dropdown.commonInit(note: viewModel.activeDates[index].note, mood: viewModel.activeDates[index].mood)
        let cellFrameInWindow = tableView.convert(cell.frame, to: view)
        if (dropdownOriginY + 290) > tableView.frame.height {
            dropdownOriginY = cellFrameInTableView.minY - 290
        }
        dropdown.frame = CGRect(x: 50,
                                y: dropdownOriginY,
                                width: cellFrameInWindow.width - 100,
                                height: 290)
        self.notesTableView.addSubview(dropdown)
        dropdownView = dropdown
    }
    
    func hideDropdown(_ dropdown: UIView) {
        dropdown.removeFromSuperview()
        dropdownView = nil
    }
    
    func createDropDownView() -> NoteDropDownView {
        let dropdown = NoteDropDownView.instanceFromNib()
        return dropdown
    }
    
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        }
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.activeDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        cell.setupContent(date: viewModel.activeDates[indexPath.section].date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            if let dropdown = dropdownView {
                hideDropdown(dropdown)
                if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                    cell.arrowImageView.isHighlighted = false
                }
            }
            selectedIndexPath = nil
        } else {
            if let dropdown = dropdownView {
                hideDropdown(dropdown)
                if let notesCell = tableView.cellForRow(at: selectedIndexPath!) as? NoteTableViewCell {
                    notesCell.arrowImageView.isHighlighted = false
                }
            }
            let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell
            showDropDown(below: cell, in: tableView, index: indexPath.section)
            cell?.arrowImageView.isHighlighted = true
            selectedIndexPath = indexPath
        }
    }
}
