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
        
        let homeViewController = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        
        let tabBarController = UITabBarController()
        let calculateNavController = NotesViewController()
        let secondNavController = UINavigationController(rootViewController: calculateNavController)
        
        tabBarController.viewControllers = [homeNavController, calculateNavController]
        
        let homeTabBarItem = UITabBarItem(title: "Ana Sayfa", image: nil, tag: 0)
        homeNavController.tabBarItem = homeTabBarItem
        
        let secondTabBarItem = UITabBarItem(title: "Hesapla", image: nil, tag: 1)
        calculateNavController.tabBarItem = secondTabBarItem
        
        tabBarController.tabBar.barTintColor = .purple
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

