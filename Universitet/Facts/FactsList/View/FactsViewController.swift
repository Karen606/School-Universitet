//
//  FactsViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class FactsViewController: UIViewController {

    @IBOutlet weak var factsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    private let viewModel = FactsViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        factsTableView.delegate = self
        factsTableView.dataSource = self
        factsTableView.register(UINib(nibName: "FactTableViewCell", bundle: nil), forCellReuseIdentifier: "FactTableViewCell")
        titleLabel.font = .medium(size: 18)
        setNavigationBar(title: "Facts")
    }
    
    @IBAction func clickedMenu(_ sender: UIButton) {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        }
    }
    
}

extension FactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.facts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactTableViewCell", for: indexPath) as! FactTableViewCell
        cell.setupContent(fact: viewModel.facts[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section < viewModel.facts.count ? 44 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let factVC = FactViewController(nibName: "FactViewController", bundle: nil)
        factVC.factModel = viewModel.facts[indexPath.section]
        self.navigationController?.pushViewController(factVC, animated: true)
    }
}



