//
//  UserDataManager.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.01.2024.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()

    private let squareDataKey = "SquareCollectionViewCell"

    private init() {}

    func saveSquareData(_ data: [SquareData]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: squareDataKey)
        }
    }

    func loadSquareData() -> [SquareData] {
        if let savedData = UserDefaults.standard.data(forKey: squareDataKey) {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([SquareData].self, from: savedData) {
                return loadedData
            }
        }
        return []
    }
    
    func removeSquareData(at index: Int) {
          var currentData = loadSquareData()
          guard index < currentData.count else { return }
          currentData.remove(at: index)
          saveSquareData(currentData)
      }
}
