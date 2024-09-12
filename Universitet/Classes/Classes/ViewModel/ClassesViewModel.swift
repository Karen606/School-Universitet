//
//  ClassesViewModel.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation
import CoreData
import UIKit

class ClassesViewModel {
    static let shared = ClassesViewModel()
    @Published var days: [DayModel] = []
    
    private init() {
        getDays()
    }
    
    func getDays() {
        if let data = UserDefaults.standard.data(forKey: .days),
           let decodedData = try? JSONDecoder().decode([DayModel].self, from: data) {
            days = decodedData
        }
    }
}
