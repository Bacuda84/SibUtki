//
//  DayCell.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let result = UILabel()
        result.font = .preferredFont(forTextStyle: .body)
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .center
        return result
    }()
    
    let dateLabel: UILabel = {
        let result = UILabel()
        result.font = .preferredFont(forTextStyle: .subheadline)
        result.textColor = UIColor.secondaryLabel
        result.adjustsFontForContentSizeCategory = true
        result.textAlignment = .center

        return result
    }()
    
    var date = Date()
    
    lazy var stackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [dayLabel, dateLabel])
        result.axis = .vertical
        result.spacing = UIStackView.spacingUseSystem
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    //MARK: - наполнение -
    public func configure(_ day: String, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        dayLabel.text = day
        dateLabel.text = formatter.string(from: date)
        self.date = date
    }
    
    //MARK: - select/unSelect -
    func selected() {
        dateLabel.backgroundColor = .systemYellow
        dateLabel.layer.cornerRadius = dateLabel.bounds.height/2
        dateLabel.textColor = .black
        dateLabel.clipsToBounds = false
    }
    public func unSelect() {
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = .secondaryLabel
    }
}
