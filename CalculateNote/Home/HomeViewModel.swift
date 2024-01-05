//
//  HomeViewModel.swift
//  CalculateNote
//
//  Created by Onur Emren on 2.01.2024.
//

import Foundation

class HomeViewModel {
    private var studentList: [StudentAndNotesModel] = []
    private var className: String?
    
    init(className: String) {
        self.className = className
    }
    
    func calculateAverage(for student: StudentAndNotesModel) -> Double {
        let grade1 = student.grades[0] * 0.5
        let grade2 = student.grades[1] * 0.25
        let grade3 = student.grades[2] * 0.25
        return (grade1 + grade2 + grade3)
    }
    
    func saveNamesAndNotes() {
        guard let className = className else { return }
        
        do {
            let encodedData = try JSONEncoder().encode(studentList)
            UserDefaults.standard.set(encodedData, forKey: className)
        } catch {
            print("Verileri kaydederken bir hata oluştu: \(error.localizedDescription)")
        }
    }
    
    func loadNamesAndNotes() {
        guard let className = className,
              let savedData = UserDefaults.standard.data(forKey: className),
              let loadedStudents = try? JSONDecoder().decode([StudentAndNotesModel].self, from: savedData) else {
            return
        }
        
        studentList = loadedStudents
    }
    
    func getNamesAndNotes() -> [StudentAndNotesModel] {
        return studentList
    }
    
    func updateNamesAndNotesList(_ updatedList: [StudentAndNotesModel]) {
        studentList = updatedList
    }
}
