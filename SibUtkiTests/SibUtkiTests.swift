//
//  SibUtkiTests.swift
//  SibUtkiTests
//
//  Created by Bakhtovar Akhmedov on 28.10.2025.
//

import XCTest
@testable import SibUtki

final class SibUtkiTests: XCTestCase {
    
    var router: RouterProtocol!
    var networkService: MockNetworkService!
    var mainView: MainViewProtocol!
    var modalView: ModalViewProtocol!
    

    override func setUpWithError() throws {
        let networkService = MockNetworkService()
        self.networkService = networkService
        self.router = MockRouter(networkService: networkService)
        mainView = router.rootView
        
    }
    
    func testSettingDefaultGroup() {
        mainView.presenter.setDefaultGroup("Baz")
        if let group = UserDefaults.standard.string(forKey: "group") {
            let groupFromPresenter = mainView.presenter.getDefaultGroup()
            XCTAssertEqual(group, "Baz")
            XCTAssertEqual(groupFromPresenter, "Baz")
            
            UserDefaults.standard.removeObject(forKey: "group")  //сразу очищаем с дефолтс
            return
        }
        
        XCTFail("Не работает сохранение группы")
    }
    
    func testShowModalView() {
        router.showModalView()             //если модальное окно создано, то через router
        XCTAssertNotNil(router.modalView)  //оно найдется обязательно
    }
    
    func testUpdatingSchedule() {
        //на fail
        let expectation = XCTestExpectation(description: "на fail")
        networkService.shouldFail = true
        mainView.presenter.updateSchedule([.now])
        mainView.presenter.setDefaultGroup("Baz")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { []
            XCTAssertTrue(self.mainView.presenter.schedule.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        let expectationForTrue = XCTestExpectation(description: "на true")
        //на рабочий апи
        networkService.shouldFail = false
        mainView.presenter.updateSchedule([.now])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.mainView.presenter.schedule.isEmpty)
            expectationForTrue.fulfill()
        }
        
        wait(for: [expectationForTrue])
        UserDefaults.standard.removeObject(forKey: "group")  //сразу очищаем с дефолтс
    }
    
    func testModalPresenter() {
        router.showModalView()
        
        networkService.shouldFail = true
        let expectationToFail = XCTestExpectation(description: "на fail")
        router.modalView?.presenter.getGroups()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            XCTAssertTrue(self.router.modalView!.presenter.groups.isEmpty)  //! оправдан, так как мы сверху создаем modalView
            expectationToFail.fulfill()
        }
        
        wait(for: [expectationToFail])
        
        
        networkService.shouldFail = false
        let expectationToTrue = XCTestExpectation(description: "на true")
        router.modalView?.presenter.getGroups()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            XCTAssertFalse(self.router.modalView!.presenter.groups.isEmpty)  //! оправдан, так как мы сверху создаем modalView
            expectationToTrue.fulfill()
        }
        
        wait(for: [expectationToTrue])
    }
    
    override func tearDownWithError() throws {
        router = nil
        networkService = nil
        mainView = nil
        modalView = nil
    }
}
