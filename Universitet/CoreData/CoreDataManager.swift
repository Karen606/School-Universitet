//
//  CoreDataManager.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createDay(_ dayModel: Day) {
        guard let dayEntityDescription = NSEntityDescription.entity(forEntityName: "Day", in: context) else { return }
        let day = Day(entity: dayEntityDescription, insertInto: context)
        day.date = dayModel.date
        day.dayName = dayModel.dayName
        day.isActiveDay = dayModel.isActiveDay
        day.classes = dayModel.classes
        day.mood = dayModel.mood
        day.note = dayModel.note
        appDelegate.saveContext()
    }
    
    public func fetchDays () -> [Day] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        do {
            return (try? context.fetch(fetchRequest) as? [Day]) ?? []
        }
    }
}
