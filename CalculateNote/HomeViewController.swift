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
    var studentView = StudentsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudents()
        setupTableView()
        createStudentList()
        setTableView()
        setupTapGestureRecognizer()
        view.backgroundColor = .systemMint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    private func setTableView() {
        studentView.nameTextField.text = ""
        studentView.gradeTextField1.text = ""
        studentView.gradeTextField2.text = ""
        studentView.gradeTextField3.text = ""
    }
    
    private func saveStudents() {
        do {
            // Öğrenci listesini Data'ya dönüştür ve UserDefaults'a kaydet
            let encodedData = try JSONEncoder().encode(studentList)
            UserDefaults.standard.set(encodedData, forKey: "studentsKey")
        } catch {
            print("Verileri kaydederken bir hata oluştu: \(error.localizedDescription)")
        }
    }
    
    private func loadStudents() {
        if let savedData = UserDefaults.standard.data(forKey: "studentsKey"),
           let loadedStudents = try? JSONDecoder().decode([Students].self, from: savedData) {
            studentList = loadedStudents
        }
    }
    
    private func createStudentList() {
        for _ in 1...40 {
            let student = Students(name: "")
            studentList.append(student)
        }
    }
    
    private func setupTableView() {
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
        
        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Hesapla", for: .normal)
        calculateButton.tintColor = .white
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        view.addSubview(calculateButton)
        
        calculateButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
    
    @objc private func calculateButtonTapped() {
        for (index, student) in studentList.enumerated() {
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
        saveStudents()
    }

    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func dismissKeyboard() {
        view.endEditing(true)
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
        cell.nameTextField.delegate = cell
        cell.gradeTextField1.delegate = cell
        cell.gradeTextField2.delegate = cell
        cell.gradeTextField3.delegate = cell
        cell.updateUI(with: student)
        cell.updateResultLabel(withAverage: calculateAverage(for: student))
        cell.backgroundColor = .systemMint
        return cell
    }
    
    func calculateAverage(for student: Students) -> Double {
        let grade1 = student.grades[0] * 0.5
        let grade2 = student.grades[1] * 0.25
        let grade3 = student.grades[2] * 0.25
        return (grade1 + grade2 + grade3)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
