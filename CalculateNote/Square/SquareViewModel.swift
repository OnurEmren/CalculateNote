//
//  SquareViewModel.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import Foundation

class SquareViewModel {
    private var squareData: [SquareData] = []
    private let squareViewControllerKey = "SquareViewControllerKey"
    private var squareView = SquareView()

    func saveData(withKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(squareData)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("SquareData Kaydedilirken Hata Oluştu: \(error.localizedDescription)")
        }
    }
}
