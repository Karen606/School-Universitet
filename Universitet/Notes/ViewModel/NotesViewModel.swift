//
//  NotesViewModel.swift
//  Universitet
//
//  Created by Karen Khachatryan on 12.09.24.
//

import Foundation

class NotesViewModel {
    static let shared = NotesViewModel()
    @Published var activeDates: [DayModel] = []
    private init() {
        fetchData()
    }
    
    func fetchData() {
        if let data = UserDefaults.standard.data(forKey: .days),
           let decodedData = try? JSONDecoder().decode([DayModel].self, from: data) {
            activeDates = decodedData.sorted(by: { $0.date > $1.date })
        }
    }
}
