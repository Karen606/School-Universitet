//
//  CreateClassViewModel.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import Foundation

class CreateClassViewModel {
    static let shared = CreateClassViewModel()
    var dayModel: DayModel?
    @Published var isActiveDay: Bool = true
    @Published var classes: [Classes] = [Classes(name: "", date: "")]
    @Published var mood: Mood?
    @Published var isValidate: Bool = false
    
    var date: Date?
    var dayName: String?
    var note: String?
    var previousClassesCount: Int = 0

    private init() { }
    
    func changeStudyingDay(isStudying: Bool) {
        self.isActiveDay = isStudying
        checkFields()
    }
    
    func changeMood(mood: Mood) {
        self.mood = mood
        checkFields()
    }
    
    func changeClassName(name: String?, _at index: Int) {
        classes[index].name = name ?? ""
        checkFields()
    }
    
    func changeClassDate(date: String?, _at index: Int) {
        classes[index].date = date ?? ""
        checkFields()
    }
    
    func changeDayName(name: String?) {
        dayName = name
        checkFields()
    }
    
    func addClasses() {
        classes.append(Classes(name: "", date: ""))
        checkFields()
    }
    
    func changeNote(note: String?) {
        self.note = note
        checkFields()
    }
    
    func createClasses() -> Bool {
        guard let mood = self.mood, let note = self.note, let date = date else { return false }
        if isActiveDay {
            dayModel = DayModel(isActiveDay: isActiveDay, date: date, dayName: dayName, classes: classes, note: note, mood: mood)
        } else {
            dayModel = DayModel(isActiveDay: isActiveDay, date: date, note: note, mood: mood)
        }
        var daysModel: [DayModel] = []
        if let data = UserDefaults.standard.data(forKey: .days),
           let decodedProjects = try? JSONDecoder().decode([DayModel].self, from: data) {
            daysModel = decodedProjects
        }
        if let dayModel = self.dayModel {
            daysModel.append(dayModel)
            if let encodedProjects = try? JSONEncoder().encode(daysModel) {
                UserDefaults.standard.set(encodedProjects, forKey: .days)
                return true
            }
        }
        return false
    }
    
    private func checkFields() {
        if !isActiveDay {
            isValidate = (mood != nil && !(note?.isEmpty ?? true))
            return
        }
        guard let mood = self.mood, let dayName = self.dayName, let note = self.note, !classes.contains(where: { $0.name.isEmpty || $0.date.isEmpty }) else { isValidate = false
            return
        }
        isValidate = classes.contains(where: { !$0.name.isEmpty && !$0.date.isEmpty }) && !dayName.isEmpty && !note.isEmpty
    }
    
    func clear() {
        dayModel = nil
        isActiveDay = true
        classes = [Classes(name: "", date: "")]
        mood = nil
        isValidate = false
        date = Date.currentDay()
        dayName = nil
        note = nil
        previousClassesCount = 0
        date = nil
    }
}
