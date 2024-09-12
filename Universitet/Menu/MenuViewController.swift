//
//  MenuViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var categoriesButtonArray: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesButtonArray.forEach({ $0.titleLabel?.font = .semibold(size: 24) })
    }
    
    @IBAction func clickedClasses(_ sender: UIButton) {
        let classesVC = ClassesViewController(nibName: "ClassesViewController", bundle: nil)
        navigationController?.pushViewController(classesVC, animated: true)
    }
    
    @IBAction func clickedNotes(_ sender: UIButton) {
        let notesVC = NotesViewController(nibName: "NotesViewController", bundle: nil)
        navigationController?.pushViewController(notesVC, animated: true)

    }

    @IBAction func clickedFacts(_ sender: UIButton) {
        let factsVC = FactsViewController(nibName: "FactsViewController", bundle: nil)
        navigationController?.pushViewController(factsVC, animated: true)
    }
    
    @IBAction func clickedSettings(_ sender: UIButton) {
//        let notesVC = NotesViewController(nibName: "NotesViewController", bundle: nil)
//        navigationController?.pushViewController(notesVC, animated: true)
    }
}
