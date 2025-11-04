//
//  Presenter.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 28.10.2025.
//

import Foundation

protocol MainViewProtocol {
    var presenter: MainPresenterProtocol! { get set }
    var delegate: SwipeDayDelegate? { get set}
    func updateTableView()
}

protocol MainPresenterProtocol {
    var schedule: [Schedule] { get set }
    var view: MainViewProtocol! { get set }
    var router: RouterProtocol! { get set }
    var networkService: NetworkProtocol! { get set }
    func setDays(_ days: String)  //поддержка диопазона дней в версии 2.0 :]
    func updateSchedule(_ dates: [Date])
    func setDefaultGroup(_ group: String) //группы
    func getDefaultGroup() -> String
}

class MainPresenter: MainPresenterProtocol {
    var router: RouterProtocol!
    var view: MainViewProtocol!
    var networkService: NetworkProtocol!
    var schedule: [Schedule] = []
    
    func updateSchedule(_ dates: [Date]) {
        print(UserDefaults.standard.string(forKey: "group")) //для отладки
        guard let group = UserDefaults.standard.string(forKey: "group") else { return }
        networkService.getSchedule(group, dates: dates) {[weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                switch result {
                case .success(let answer):
                    self.schedule = answer?.days ?? []
                    self.view.updateTableView()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func setDefaultGroup(_ group: String) {
        let defaults = UserDefaults.standard
        defaults.set(group, forKey: "group")
        print("Сохранено:", defaults.string(forKey: "group") ?? "ошибка")
    }
    
    func setDays(_ days: String) {
        //для версии 2.0 :]
    }
    
    func getDefaultGroup() -> String {
        return UserDefaults.standard.string(forKey: "group") ?? "Выбор группы"
    }
}


