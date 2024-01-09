//
//  AppDelegate.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navVC = UINavigationController()
        
        let coordinator = AppCoordinator()
        coordinator.navigationController = navVC
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
        
        //MARK: - App Scene Control.
        
        // if the user launched before the app, app should be go to MainScreen else, onBoarding Screen.
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            coordinator.onBoardingStart()
        } else {
            coordinator.start()
        }
        return true
    }
    
    func showOnboardingScreen() {
        let onboardingViewController = ManageOnBoardingViewController()
        let navigationController = UINavigationController(rootViewController: onboardingViewController)
        window?.rootViewController = navigationController
    }
    
    func showMainScreen() {
        let squareViewController = SquareViewController()
        let squareNavController = UINavigationController(rootViewController: squareViewController)
        window?.rootViewController = squareNavController
    }
}


