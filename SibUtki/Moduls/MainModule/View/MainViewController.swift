//
//  MainViewController.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 28.10.2025.
//

import Foundation
import UIKit

protocol SwipeDayDelegate {
    func plusDay()
    func minusDay()
    func getCurrentDay() -> Date?
}

class MainTableViewController: UITableViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol!
    var delegate: SwipeDayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(TopCell.self, forCellReuseIdentifier: "TopCell")
        tableView.register(WeekDaysChangeCell.self, forCellReuseIdentifier: "WeekDaysChangeCell")
        tableView.register(LessonCell.self, forCellReuseIdentifier: "LessonCell")
        refreshControl = DuckRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        let indicator = UIActivityIndicatorView(style: .medium)
        print(indicator.bounds.size)
        
        addSwipeGestures(to: tableView)
    }
    
    //UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1+presenter.schedule.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        default:
            let count = presenter.schedule[section-1].lessons.count
            
            return count == 0 ? 1 : presenter.schedule[section-1].lessons.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        default:
            return presenter.schedule[section-1].weekday+" "+presenter.schedule[section-1].date
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedBackgroudView = UIView()
        selectedBackgroudView.backgroundColor = .clear
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
                cell.configure(string: presenter.getDefaultGroup())
                cell.delegate = self
                print(indexPath)
                cell.selectedBackgroundView = selectedBackgroudView
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDaysChangeCell", for: indexPath) as! WeekDaysChangeCell
                cell.collectionView.ourDelegate = self
                cell.selectedBackgroundView = selectedBackgroudView
                self.delegate = cell.collectionView

                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as! LessonCell
                cell.configure(From: presenter.schedule[indexPath.row-2].lessons[0])
                cell.selectedBackgroundView = selectedBackgroudView

                return cell
                
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as? LessonCell, presenter.schedule[indexPath.section-1].lessons.count > 0 {
                print(indexPath)
                cell.configure(From: presenter.schedule[indexPath.section-1].lessons[indexPath.row])
                cell.selectedBackgroundView = selectedBackgroudView
                return cell
            }
            let cellNoLessons = UITableViewCell()
            cellNoLessons.textLabel?.text = "Нету Пар!"
            cellNoLessons.selectedBackgroundView = selectedBackgroudView

            return cellNoLessons
        }
    }
    
    //refreshData
    @objc func refreshData() {
        if  let date = delegate?.getCurrentDay(){
            refreshControl?.beginRefreshing()
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.presenter.updateSchedule([date])
            }
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    
    
    //UISwipeGesture
    private func addSwipeGestures(to view: UIView) {
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightGesture))
        rightGesture.direction = .right
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture))
        leftGesture.direction = .left

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(leftGesture)
        view.addGestureRecognizer(rightGesture)
        
    }
    
    @objc func rightGesture() {
        delegate?.minusDay()
    }
    
    @objc func leftGesture() {
        delegate?.plusDay()
    }
    
    //MainViewProtocol
    func updateTableView() {
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
}

//MARK: - делегаты ячеек/модального окна -
//обработка выбора дня недели
extension MainTableViewController: DaysCollectionViewProtocol {
    func selected(_ date: Date) {
        presenter.updateSchedule([date])
    }
}
//обработка нажания на выбор Группы
extension MainTableViewController: TopCellDelegate {
    func showModal() {
        presenter.router.showModalView()
    }
}
//обработка выбора Группы через модальное окно
extension MainTableViewController: ModalViewDelegate {
    func changeGroup(_ string: String) {
        presenter.setDefaultGroup(string)
        tableView.reloadRows(at: [.init(row: 0, section: 0)], with: .none)
    }
}
