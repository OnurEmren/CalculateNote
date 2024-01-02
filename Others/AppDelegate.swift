//
//  AppDelegate.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import UIKit
import SideMenu

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let squareViewController = SquareViewController()
        let homeNavController = UINavigationController(rootViewController: squareViewController)
                
        window?.rootViewController = homeNavController
        window?.makeKeyAndVisible()
        
        return true
    }
}

