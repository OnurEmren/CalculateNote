//
//  StudentCount.swift
//  CalculateNote
//
//  Created by Onur Emren on 9.01.2024.
//

import Foundation

struct StudentCount {
    var name: String
    var students: [StudentAndNotesModel]
    
    init(name: String, students: [StudentAndNotesModel]) {
        self.name = name
        self.students = students
    }
}
