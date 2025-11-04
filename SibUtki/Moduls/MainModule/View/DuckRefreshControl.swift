//
//  DuckRefreshControl.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 31.10.2025.
//

import UIKit

class DuckRefreshControl: UIRefreshControl {
    
    private let avatarImageView = UIImageView(image: .logo)
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        tintColor = .clear
        
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 15
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        startRotating()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        stopRotating()
    }
    
    //rotating логика
    private func startRotating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 4
        rotation.duration = 1
        rotation.repeatCount = .infinity
        avatarImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func stopRotating() {
        avatarImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
