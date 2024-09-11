//
//  Day+CoreDataProperties.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var isActiveDay: Bool
    @NSManaged public var date: Date
    @NSManaged public var dayName: String?
    @NSManaged public var mood: String
    @NSManaged public var note: String
    @NSManaged public var classes: [Classes]?

}

extension Day : Identifiable {

}
