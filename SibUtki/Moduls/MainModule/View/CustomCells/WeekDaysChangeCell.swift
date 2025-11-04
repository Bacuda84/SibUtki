//
//  WeekDaysChangeCell.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 29.10.2025.
//

import UIKit

class WeekDaysChangeCell: UITableViewCell {
    
    var collectionView: DaysCollectionView!
    
    private let flowLayout = UICollectionViewFlowLayout()  //можно через compositionalLayout, он будет в 2.0 :]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Настройка layout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        // Создание коллекции
        collectionView = DaysCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Обновляем размеры item’ов только при изменении ширины
        let newItemWidth = contentView.frame.width / 7
        if flowLayout.itemSize.width != newItemWidth {
            flowLayout.itemSize = CGSize(width: newItemWidth, height: contentView.frame.height)
            flowLayout.invalidateLayout()
        }
    }
}
