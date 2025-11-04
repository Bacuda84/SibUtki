//
//  MockViews.swift
//  SibUtkiTests
//
//  Created by Bakhtovar Akhmedov on 04.11.2025.
//

import Foundation
import XCTest
@testable import SibUtki

//MARK: - MockMainView -
class MockMainView: MainViewProtocol, ModalViewDelegate {

    var presenter: SibUtki.MainPresenterProtocol!
    
    var delegate: SibUtki.SwipeDayDelegate?
    
    func updateTableView() {
        //якобы показываем все уроки
    }
    
    func changeGroup(_ string: String) {
        presenter.setDefaultGroup(string)
    }
    
}

//MARK: - MockModalView -
class MockModalView: ModalViewProtocol {
    var delegate: SibUtki.ModalViewDelegate?
    
    var presenter: (any SibUtki.ModalPresenterProtocol)!
    
    func setGroups() {
        //якобы показываем все группы
    }
    
    func setGroup() {  //в настоящем вью как таргет идёт
        delegate?.changeGroup(presenter.groups[0].institutes[0].courses[0].groups[0])
    }
}

//MARK: - MockBuilder -
class MockBuilder {
    func configureMainView(networkService: NetworkProtocol) -> MainViewProtocol {
        let presenter = MainPresenter()
        let view = MockMainView()
        presenter.view = view
        presenter.networkService = networkService
        view.presenter = presenter
        
        return view
    }
    
    func configureModalView(networkService: NetworkProtocol) -> ModalViewProtocol {
        let presenter = ModalPresenter()
        let view = MockModalView()
        presenter.view = view
        presenter.networkService = networkService
        view.presenter = presenter
        
        return view
    }
}

//MARK: - MockRouter -
class MockRouter: RouterProtocol {
    
    let builder = MockBuilder()
    var networkService: NetworkProtocol!
    var rootView: MainViewProtocol!
    var modalView: ModalViewProtocol?
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
        self.rootView = builder.configureMainView(networkService: networkService)
        rootView.presenter.router = self
    }
    func showModalView() {
        // Проверяем, что оба не nil
        if var mockModalView = modalView,
           let delegate = rootView as? ModalViewDelegate {
            mockModalView.delegate = delegate
        } else if let delegate = rootView as? ModalViewDelegate {
            modalView = builder.configureModalView(networkService: networkService)
            modalView?.delegate = delegate
            
        } else {
            XCTFail("Нету делегата")
        }
    }
}

//MARK: - MockNetworkService -
class MockNetworkService: NetworkProtocol {
    var url: String = ""
    
    var shouldFail = false
    
    func getSchedule(_ group: String, dates: [Date], completion: @escaping (Result<SibUtki.AnswerForSchedule?, any Error>) -> Void) {
        if shouldFail {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        let response = AnswerForSchedule.init(group: "Baz", days: [.init(date: "Bar", weekday: "Foo", weekType: "Bax", lessons: [])])
        completion(.success(response))
    }
    
    
    
    func getGroups(_ completion: @escaping (Result<SibUtki.GroupListResponse?, any Error>) -> Void) {
        if shouldFail {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        let response = GroupListResponse.init(institutes: [.init(name: "Buz", courses: [])])
        completion(.success(response))
    }
}
