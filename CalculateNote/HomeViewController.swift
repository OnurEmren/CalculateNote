//
//  ViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var studentList = [Students]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        createStudentList()
        
        view.backgroundColor = .systemMint
    }
    
    func createStudentList() {
        for i in 1...40 {
            let student = Students(name: "Öğrenci \(i)")
            studentList.append(student)
        }
    }
    
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StudentsView.self, forCellReuseIdentifier: "StudentCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        let footerView = UIView()
        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Hesapla", for: .normal)
        calculateButton.tintColor = .white
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        footerView.addSubview(calculateButton)
        
        calculateButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        view.addSubview(footerView)
        
        footerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.height.equalTo(40)
            make.width.equalTo(100)

        }
    }
    
    @objc func calculateButtonTapped() {
        for (index, student) in studentList.enumerated() {
            // Her öğrencinin notlarını al
            let grade1 = student.grades[0] * 0.5
            let grade2 = student.grades[1] * 0.25
            let grade3 = student.grades[2] * 0.25

            // Ortalamayı hesapla
            let average = (grade1 + grade2 + grade3)

            // Her öğrencinin resultLabel'ına not ortalamasını yerleştir
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StudentsView {
                cell.updateResultLabel(withAverage: average)
            }
        }
    }

    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentsView
        let student = studentList[indexPath.row]
        cell.student = student
        cell.nameLabel.text = "\(student.name)"
        cell.backgroundColor = .systemMint
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
