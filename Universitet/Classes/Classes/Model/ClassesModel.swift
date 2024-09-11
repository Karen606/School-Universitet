//
//  ClassesModel.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation

struct DayModel {
    var isActiveDay: Bool
    var date: Date
    var dayName: String?
    var classes: [Class]?
    var note: String
    var mood: String
}

struct Class {
    var name: String
    var date: String
}

//enum Mood {
//    case good
//    case medium
//    case poor
//}
