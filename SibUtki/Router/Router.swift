//
//  Router.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var rootView: MainViewProtocol! { get set }
    var modalView: ModalViewProtocol? { get set }
    func showModalView()
}

class Router: RouterProtocol {
    var rootView: MainViewProtocol!
    var modalView: ModalViewProtocol?
    var builder: BuilderProtocol = Builder()
    
    init() {
        setMainVC()
    }
    func setMainVC() {
        let root = builder.getMainModule(router: self)
        rootView = root
    }
    
    func showModalView() {
        guard let mainVC = rootView as? MainViewProtocol else { return }
        
        let modalViewController = modalView != nil ? modalView as! ModalSheetViewController: builder.getModalModule()
        
        modalViewController.modalPresentationStyle = .pageSheet
        if let sheet = modalViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        
        if let rootView = rootView as? MainTableViewController {
            modalViewController.delegate = rootView.self
        }
        
        
        (rootView as! UIViewController).present(modalViewController, animated: true, completion: nil)
        modalView = modalViewController
    }
}
