//
//  DayInfoViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import UIKit

class DayInfoViewController: UIViewController {

//    @IBOutlet weak var moodBgView: UIView!
//    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classesTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var compeltion: (() -> ())?
    var dayModel: DayModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.background.cgColor
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = UIColor.background.withAlphaComponent(0.25)
        dateLabel.attributedText = formatDate(date: dayModel.date)
        dateLabel.sizeToFit()
        classesTableView.backgroundColor = .clear
        classesTableView.showsHorizontalScrollIndicator = false
        classesTableView.showsVerticalScrollIndicator = false
        classesTableView.delegate = self
        classesTableView.dataSource = self
        classesTableView.register(UINib(nibName: "ClassesTableViewCell", bundle: nil), forCellReuseIdentifier: "ClassesTableViewCell")
        classesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesTableViewCell")
    }
    
    func formatDate(date: Date) -> NSMutableAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "d EEEE"
        let formattedDate = formatter.string(from: date)
        let dateComponents = formattedDate.split(separator: " ")
        let dayNumber = String(dateComponents[0])
        let weekday = String(dateComponents[1])
        let dayNumberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.medium(size: 24) as Any
        ]
        let attributedDayNumber = NSAttributedString(string: dayNumber, attributes: dayNumberAttributes)
        let weekdayAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.medium(size: 14) as Any
        ]
        let attributedWeekday = NSAttributedString(string: " " + weekday, attributes: weekdayAttributes)
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(attributedDayNumber)
        finalAttributedString.append(attributedWeekday)
        return finalAttributedString
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: compeltion)
    }
    @IBAction func clickedBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: compeltion)
    }
}


extension DayInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dayModel.isActiveDay ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dayModel.classes?.count ?? 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if dayModel.isActiveDay {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesTableViewCell", for: indexPath) as! ClassesTableViewCell
                cell.setupContentForRead(model: dayModel.classes?[indexPath.row], index: indexPath.row)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
                cell.setupContent(note: dayModel.note)
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
            cell.setupContent(note: dayModel.note)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            headerView.frame.size.height = 80
            let label = UILabel()
            label.frame.size = CGSize(width: 130, height: 46)
            label.frame.origin.y = 4
            headerView.addSubview(label)
            var color: UIColor?
            switch dayModel.mood {
            case .good:
                color = #colorLiteral(red: 0.003921568627, green: 0.6078431373, blue: 0.02745098039, alpha: 1)
            case .medium:
                color = #colorLiteral(red: 0.5568627451, green: 0.3607843137, blue: 0.1254901961, alpha: 1)
            case .poor:
                color = #colorLiteral(red: 0.7921568627, green: 0, blue: 0, alpha: 1)
            }
            label.textColor = color
            label.layer.borderWidth = 2
            label.layer.borderColor = color?.cgColor
            label.layer.cornerRadius = 12
            label.font = .medium(size: 18)
            label.textAlignment = .center
            label.text = "\(dayModel.mood.id) day"
            let classesLabel = UILabel(frame: CGRect(x: 0, y: 56, width: 80, height: 20))
            classesLabel.text = dayModel.isActiveDay ? "Classes" : "Mini notes"
            classesLabel.textColor = .background
            classesLabel.font = .medium(size: 18)
            classesLabel.sizeToFit()
            headerView.addSubview(classesLabel)
            label.frame.origin.x = tableView.frame.width / 2 - label.frame.width / 2

            return headerView
        } else {
            let label = UILabel()
            label.font = .medium(size: 18)
            label.textColor = .background
            label.text = "Mini notes"
            return label
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 80 : 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
