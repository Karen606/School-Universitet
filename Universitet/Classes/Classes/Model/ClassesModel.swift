//
//  ClassesModel.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation

struct DayModel: Codable {
    var isActiveDay: Bool
    var date: Date
    var dayName: String?
    var classes: [Classes]?
    var note: String
    var mood: Mood
}

struct Classes: Codable {
    var name: String
    var date: String
}

enum Mood: Int, CaseIterable, Codable {
    case good
    case medium
    case poor
    
    var id: String {
        switch self {
        case .good:
            return "Good"
        case .medium:
            return "Medium"
        case .poor:
            return "Poor"
        }
    }
}
