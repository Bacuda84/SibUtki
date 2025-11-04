//
//  Presenter.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import Foundation

protocol ModalViewDelegate {
    func changeGroup(_ string: String)
}

protocol ModalViewProtocol{
    var presenter: ModalPresenterProtocol! { get set }
    var delegate: ModalViewDelegate? { get set }
    func setGroups()
}

protocol ModalPresenterProtocol {
    var networkService: NetworkProtocol! { get set }
    var view: ModalViewProtocol! { get set }
    var groups : [GroupListResponse] { get set }
    func getGroups()
}

class ModalPresenter: ModalPresenterProtocol {
    var groups: [GroupListResponse] = []
    var view: ModalViewProtocol!

    var networkService: NetworkProtocol!
    
    func getGroups() {
        networkService.getGroups { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let groups):
                    self.groups = [groups!]
                    self.view.setGroups()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

