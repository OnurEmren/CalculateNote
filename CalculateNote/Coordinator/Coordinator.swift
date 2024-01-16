//
//  Coordinator.swift
//  CalculateNote
//
//  Created by Onur Emren on 8.01.2024.
//

import Foundation
import UIKit

enum Event {
    case goToClassesViewControllerPage
    case goToClassroom (className: String)
    case goToSettings
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    func eventOccured(with type: Event)
    func start()
    func showOnboarding()
    func showMainScreen()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
