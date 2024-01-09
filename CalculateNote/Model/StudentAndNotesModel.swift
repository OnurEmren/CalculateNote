//
//  Students.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import Foundation

class StudentAndNotesModel: Codable {
    var name: String
    var grades: [Double?]

    init(name: String) {
        self.name = name
        self.grades = [nil, nil, nil]
    }
}
