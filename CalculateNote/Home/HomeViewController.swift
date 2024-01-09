//
//  ViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    var tableView: UITableView!
    var homeTableViewCell = HomeTableViewCell()
    var squareData: SquareData?
    var className: String?
    var studentList: [StudentAndNotesModel] = []
    var homeViewModel: HomeViewModel!
    var checkBoxView: CheckBoxView!
    var isChecked = false
    private var classAverageToDisplay: Double?
    
    init(className: String) {
        self.className = className
        self.homeViewModel = HomeViewModel(className: className)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCheckBoxView()
        setTableView()
        setupTapGestureRecognizer()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = Colors.darkThemeColor
        view.backgroundColor = Colors.appMainColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudents()
        if studentList.isEmpty {
            createStudentList()
        }
    }
    
    //MARK: - Create Student List
    
    func createStudentList() {
        var studentList: [StudentAndNotesModel] = []
        for _ in 1...50 {
            let student = StudentAndNotesModel(name: "")
            studentList.append(student)
        }
        self.studentList = studentList
        tableView.reloadData()
    }
    
    //MARK: - Private Methods
    
    // Set View
    private func setupView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.appMainColor
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        view.addSubview(tableView)
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Hesapla ve Kaydet", for: .normal)
        calculateButton.tintColor = Colors.darkThemeColor
        calculateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        view.addSubview(calculateButton)
        
        calculateButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        let averageButton = UIButton(type: .system)
        averageButton.setTitle("Ortalama", for: .normal)
        averageButton.tintColor = Colors.darkThemeColor
        averageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        averageButton.addTarget(self, action: #selector(calculateAverageButtonTapped), for: .touchUpInside)
        view.addSubview(averageButton)
        
        averageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-150)
            make.bottom.equalTo(-30)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
    
    private func setTableView() {
        homeTableViewCell.nameTextField.text = ""
        homeTableViewCell.gradeTextField1.text = ""
        homeTableViewCell.gradeTextField2.text = ""
        homeTableViewCell.gradeTextField3.text = ""
    }
    
    private func setupCheckBoxView() {
        checkBoxView = CheckBoxView()
        checkBoxView.onCheckBoxTapped = { [weak self] checkBox in
            self?.handleCheckBoxTapped(checkBox)
        }
        view.addSubview(checkBoxView)
        
        checkBoxView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(110)
            make.height.equalTo(30)
        }
    }
    
    private func handleCheckBoxTapped(_ checkBox: UIButton) {
        isChecked = !isChecked
        let checkBoxTitle = checkBox.titleLabel?.text ?? ""
        for (index, _) in studentList.enumerated() {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HomeTableViewCell {
                cell.enableTextFields(for: checkBoxTitle)
            }
        }
    }
    
    // Save and load business
    private func saveStudents() {
        homeViewModel.updateNamesAndNotesList(studentList)
        homeViewModel.saveNamesAndNotes()
    }
    
    private func loadStudents() {
        homeViewModel.loadNamesAndNotes()
        studentList = homeViewModel.getNamesAndNotes()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - @objc Methods
    
    @objc
    private func calculateButtonTapped() {
        calculateClassAverage()
        saveStudents()
    }
    
    @objc
    private func calculateAverageButtonTapped() {
        showClassAverageAlert()
    }
    
    private func calculateClassAverage() {
        var totalClassAverage = 0.0
        var enteredStudentsCount = 0
        
        for (index, student) in studentList.enumerated() {
            // Öğrencinin notlarının hepsi sıfırsa bu öğrenciyi atla
            if student.grades.allSatisfy({ $0 == nil }) {
                continue
            }
            let studentAverage = homeViewModel.calculateAverage(for: student)
            
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? HomeTableViewCell {
                cell.updateResultLabel(withAverage: studentAverage)
                cell.updateGradeTextFieldColors(cell.nameTextField)
                cell.updateGradeTextFieldColors(cell.gradeTextField1)
                cell.updateGradeTextFieldColors(cell.gradeTextField2)
                cell.updateGradeTextFieldColors(cell.gradeTextField3)
            }
            
            totalClassAverage += studentAverage
            enteredStudentsCount += 1
        }
        if enteredStudentsCount > 0 {
            let overallClassAverage = totalClassAverage / Double(enteredStudentsCount)
            classAverageToDisplay = overallClassAverage
        } else {
            print("Henüz hiç not girilmemiş.")
        }
    }
    
    private func showClassAverageAlert() {
        if let classAverage = classAverageToDisplay {
            let alertController = UIAlertController(title: "Sınıf Ortalaması", message: String(format: "%.2f", classAverage), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            print("Henüz sınıf ortalaması hesaplanmamış.")
        }
    }
    
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! HomeTableViewCell
        let student = studentList[indexPath.row]
        cell.student = student
        cell.nameTextField.delegate = cell
        cell.gradeTextField1.delegate = cell
        cell.gradeTextField2.delegate = cell
        cell.gradeTextField3.delegate = cell
        cell.updateUI(with: student)
        cell.updateResultLabel(withAverage: homeViewModel.calculateAverage(for: student))
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "\(indexPath.row + 1)"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkBoxView.updateCheckBoxState()
    }
}
