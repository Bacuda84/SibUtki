//
//  ModalSheetPC.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import UIKit

class ModalSheetViewController: UIViewController, ModalViewProtocol {
    
    var presenter: ModalPresenterProtocol!
    var delegate: ModalViewDelegate?
    
    //простая логика, в рефакторинге попробую сделать более изящное решение
    var selectedInstituteIndex = 0
    var selectedCourse = 0
    
    //MARK: - layout + подписка на dataSource && delegate-
    
    let changeInstituteLabel = makeLabel("Выберите Институт")
    let changeCourseLabel = makeLabel("Выберите Курс")
    
    var changeInstituteButton = makeMenuButton("Выбрать")
    let changeCourseButton = makeMenuButton("Выбрать")
    
    let tableView: UITableView = {
        let result = UITableView()
        result.rowHeight = UITableView.automaticDimension
        result.estimatedRowHeight = UITableView.automaticDimension
        result.translatesAutoresizingMaskIntoConstraints = false
        
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.getGroups()
    }
    
    private func setup() {
        view.addSubview(changeInstituteLabel)
        view.addSubview(changeInstituteButton)
        view.addSubview(changeCourseLabel)
        view.addSubview(changeCourseButton)
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            // Верх и отступы
            changeInstituteLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20),
            changeCourseLabel.topAnchor.constraint(equalTo: changeInstituteLabel.bottomAnchor, constant: 30),
            changeInstituteButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20),
            // Leading
            changeInstituteLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            changeCourseLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),

            // Кнопки — расположение
            changeInstituteButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            changeInstituteButton.centerYAnchor.constraint(equalTo: changeInstituteLabel.centerYAnchor),
            changeCourseButton.centerYAnchor.constraint(equalTo: changeCourseLabel.centerYAnchor),
            changeCourseButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // Таблица
            tableView.topAnchor.constraint(equalTo: changeCourseLabel.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let color = traitCollection.userInterfaceStyle == .light ? UIColor.tintColor : UIColor.systemYellow
        changeInstituteButton.layer.cornerRadius = changeInstituteButton.bounds.height/2
        changeCourseButton.layer.cornerRadius = changeCourseButton.bounds.height/2
        
        changeInstituteButton.setTitleColor(color, for: .normal)
        changeCourseButton.setTitleColor(color, for: .normal)
        
        changeInstituteButton.layer.borderColor = color.cgColor
        changeCourseButton.layer.borderColor = color.cgColor
    }
    
    static func makeLabel(_ text: String) -> UILabel {
        let result = UILabel()
        result.text = text
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = .preferredFont(forTextStyle: .body)
        result.adjustsFontForContentSizeCategory = true

        return result
    }
    
    static func makeMenuButton(_ text: String) -> UIButton {
        let result = UIButton()
        result.setTitle(text, for: .normal)
        result.setTitleColor(.systemYellow, for: .normal)
        result.menu = UIMenu.init(title: text, children: [
        ])
        result.clipsToBounds = true
        result.layer.borderWidth = 2
        result.layer.borderColor = UIColor.systemYellow.cgColor
        result.translatesAutoresizingMaskIntoConstraints = false
        result.layer.borderWidth = 2
        result.layer.borderColor = UIColor.systemYellow.cgColor
        result.titleLabel?.font = .preferredFont(forTextStyle: .body)
        result.titleLabel?.adjustsFontForContentSizeCategory = true


        result.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        return result
    }
    
    //MARK: - Небольшая логика выбора групп -
    func resetInstitutes() {
        var allActions = [UIAction]()
        
        for (index, i) in presenter.groups[0].institutes.enumerated() {
            
            allActions.append(UIAction(title: i.name, handler: { action in
                self.selectedInstituteIndex = index
                self.selectedCourse = 0
                self.changeInstituteButton.setTitle(i.name, for: .normal)
                
                resetCourses()
            }))
        }
            changeInstituteButton.menu = .init(title: "Выбрать", children: allActions)
        
        func resetCourses() {
            var allActions = [UIAction]()
            
            for (index, i) in presenter.groups[0].institutes[selectedInstituteIndex].courses.enumerated() {
                allActions.append(UIAction(title: "\(i.courseNumber)", handler: { action in
                    self.selectedCourse = index
                    self.changeCourseButton.setTitle("\(i.courseNumber)", for: .normal)

                    self.tableView.reloadData()
                }))
            }
            changeCourseButton.menu = .init(title: "Выбрать", children: allActions)
        }
    }
   
    
    
    //MARK: - ModalViewProtocol -
    func setGroups() {
        resetInstitutes()
        tableView.reloadData()
    }
}

//MARK: - dataSource && delegate-
extension ModalSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard presenter.groups.count > 0 else { return 0}
        guard selectedCourse > -1 else { return 0}
        return presenter.groups[0].institutes[selectedInstituteIndex].courses[selectedCourse].groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter.groups[0].institutes[selectedInstituteIndex].courses[selectedCourse].groups[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(presenter.groups[0].institutes[selectedInstituteIndex].courses[selectedCourse].groups[indexPath.row])
        delegate?.changeGroup(presenter.groups[0].institutes[selectedInstituteIndex].courses[selectedCourse].groups[indexPath.row])
    }
}

