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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        UINavigationBar.appearance().tintColor = UIColor.white

        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            showOnboardingScreen()
        } else {
            showMainScreen()
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

