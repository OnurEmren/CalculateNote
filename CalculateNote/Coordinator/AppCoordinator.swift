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
    private var squareData: SquareData?
    private var className: String = ""
    
    func eventOccured(with type: Event) {
        switch type {
        case .goToClassesViewControllerPage:
            let squareVC = ClassListViewController()
            navigationController?.pushViewController(squareVC, animated: true)
            
        case .goToClassroom(let className):
            let classroomController = StudentNotesViewController(className: className)
            navigationController?.pushViewController(classroomController, animated: true)
            
        case .goToSettings:
            let settingsVC = SettingsViewController()
            settingsVC.coordinator = self
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    func start() {
        let squareViewController = ClassListViewController()
        squareViewController.coordinator = self
        navigationController?.setViewControllers([squareViewController], animated: false)
    }
    
    func onBoardingStart() {
        let onBoardingVC = ManageOnBoardingViewController()
        onBoardingVC.coordinator = self
        navigationController?.setViewControllers([onBoardingVC], animated: false)
    }
}
