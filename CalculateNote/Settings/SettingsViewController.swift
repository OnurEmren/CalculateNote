//
//  SettingsViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 8.01.2024.
//

import UIKit

class SettingsViewController: UIViewController,Coordinating {
    var coordinator: Coordinator?
    private var settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.navigationBar.tintColor = Colors.lightThemeColor
        view.backgroundColor = .red
    }
    
    private func setupView() {
        settingsView = SettingsView()
        view.addSubview(settingsView)
        
        settingsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
