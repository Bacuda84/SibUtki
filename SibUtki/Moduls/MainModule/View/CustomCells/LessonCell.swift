//
//  LessonCell.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 28.10.2025.
//

import UIKit

class LessonCell: UITableViewCell {
    
    private let timeLabel: UILabel = {
        let result = UILabel()
        result.font = .preferredFont(forTextStyle: .body)
        result.textAlignment = .right
        return result
    }()
    
    
    private let typeOfLessonLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Не определено"
        result.textColor = .secondaryLabel
        result.font = .preferredFont(forTextStyle: .footnote)
        return result
    }()
    
    
    private lazy var horizontalStackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [typeOfLessonLabel, timeLabel])
        result.axis = .horizontal
        result.spacing = UIStackView.spacingUseDefault
        return result
    }()
    
    private let disciplineLabel: UILabel = {
        let result = UILabel()
        result.font = .preferredFont(forTextStyle: .caption1)
        return result
    }()
    private let classroomLabel: UILabel = {
        let result = UILabel()
        result.font = .preferredFont(forTextStyle: .body)
        return result
    }()
    private lazy var verticalStackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [disciplineLabel, classroomLabel])
        result.axis = .vertical
        result.spacing = UIStackView.spacingUseDefault
        return result
    }()
    
    private lazy var rootStackView: UIStackView = {
        let result = UIStackView(arrangedSubviews: [horizontalStackView, verticalStackView])
        result.axis = .vertical
        result.spacing = UIStackView.spacingUseDefault
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        contentView.addSubview(rootStackView)
        
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            margins.topAnchor.constraint(equalTo: rootStackView.topAnchor),
            margins.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            margins.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            margins.bottomAnchor.constraint(equalTo: rootStackView.bottomAnchor),
        ])
    }
    
    //MARK: - Наполнение через передачу модели -
    public func configure(From schedule: Lessson) {
        timeLabel.text = schedule.beginTime + " " + (schedule.endTime ?? " ")
        disciplineLabel.text = schedule.discipline
        classroomLabel.text = schedule.classroom ?? ""
        
        if (schedule.typeOfLesson ?? "").lowercased().contains("лекц") {
            typeOfLessonLabel.text = "Лекция"
            typeOfLessonLabel.textColor = .systemYellow
            typeOfLessonLabel.layer.borderColor = UIColor.systemYellow.cgColor
        } else if (schedule.typeOfLesson ?? "").lowercased().contains("прак") {
            typeOfLessonLabel.text = "Практика"
            typeOfLessonLabel.textColor = .systemBlue
            typeOfLessonLabel.layer.borderColor = UIColor.systemBlue.cgColor
        } else if (schedule.typeOfLesson ?? "").lowercased().contains("лаб") {
            typeOfLessonLabel.text = "Лабораторная работа"
            typeOfLessonLabel.textColor = .systemGreen
            typeOfLessonLabel.layer.borderColor = UIColor.systemGreen.cgColor
        }
        
    }

}
