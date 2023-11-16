//
//  NotesViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 15.11.2023.
//

import UIKit

class NotesViewController: UIViewController {
    var tableView: UITableView!
    var studentList = [Students]()
    var studentView = StudentsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
    }
}
