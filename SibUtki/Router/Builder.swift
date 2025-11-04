//
//  Builder.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 29.10.2025.
//

import Foundation

protocol BuilderProtocol {
    func getMainModule(router: RouterProtocol) -> MainTableViewController 
    func getModalModule() -> ModalSheetViewController
}

class Builder: BuilderProtocol{
    func getMainModule(router: RouterProtocol) -> MainTableViewController {
        let view = MainTableViewController()
        let presenter = MainPresenter()
        let networkService = NetworkService()
        presenter.networkService = networkService
        presenter.view = view
        presenter.router = router
        view.presenter = presenter

        return view
    }
    
    func getModalModule() -> ModalSheetViewController {
        let view = ModalSheetViewController()
        let presenter = ModalPresenter()
        let networkService = NetworkService()
        presenter.networkService = networkService
        presenter.view = view
        view.presenter = presenter

        return view
    }
}
