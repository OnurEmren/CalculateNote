//
//  AppCoordinator.swift
//  CalculateNote
//
//  Created by Onur Emren on 8.01.2024.
//

import Foundation
import UIKit
import Combine

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    private var squareData: SquareData?
    private var className: String = ""
    let hasSeenOnboarding = CurrentValueSubject<Bool,Never>(false)
    var subscriptions = Set<AnyCancellable>()
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func eventOccured(with type: Event) {
        switch type {
        case .goToClassesViewControllerPage:
            let squareVC = ClassListViewController()
            squareVC.coordinator = self
            navigationController?.pushViewController(squareVC, animated: true)
            
        case .goToClassroom(let className):
            let classroomController = StudentNotesViewController(className: className)
            classroomController.coordinator = self
            navigationController?.pushViewController(classroomController, animated: true)
            
        case .goToSettings:
            let settingsVC = SettingsViewController()
            settingsVC.coordinator = self
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    func start() {
        navigationController = UINavigationController()
        if UserDefaults.standard.bool(forKey: "onboardingShown") {
            showMainScreen()
        } else {
            showOnboarding()
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingShown")
        let onboardingVC = ManageOnBoardingViewController()
        onboardingVC.coordinator = self
        navigationController?.pushViewController(onboardingVC, animated: false)
    }
    
    func showMainScreen() {
        let classListVC = ClassListViewController()
        classListVC.coordinator = self
        navigationController?.pushViewController(classListVC, animated: false)
    }
}
