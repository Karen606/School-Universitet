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
    @Published var days: [Day] = []
    
    private init() {
        getDays()
    }
    
    func getDays() {
        self.days = CoreDataManager.shared.fetchDays()
    }
    
}
