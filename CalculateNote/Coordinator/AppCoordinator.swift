//
//  AppCoordinator.swift
//  CalculateNote
//
//  Created by Onur Emren on 8.01.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    func eventOccured(with type: Event) {
        switch type {
        case .goToSquareViewController:
            let squareVC = SquareViewController()
            navigationController?.pushViewController(squareVC, animated: true)
            
        case .goToClassroom(let squareData, let className):
            let classroomController = HomeViewController(squareData: squareData, className: className)
            navigationController?.pushViewController(classroomController, animated: true)
            
        case .goToSettings:
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    func start() {
        let onBoardingVC = ManageOnBoardingViewController()
        onBoardingVC.coordinator = self
        navigationController?.setViewControllers([onBoardingVC], animated: false)

    }
}
