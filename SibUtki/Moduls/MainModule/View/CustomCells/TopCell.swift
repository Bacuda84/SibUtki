//
//  TopCell.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 29.10.2025.
//

import UIKit

//MARK: - TopCellDelegate -
protocol TopCellDelegate {
    func showModal()
}

//MARK: - TopCell -
class TopCell: UITableViewCell {
    
    var delegate: TopCellDelegate!
    
    let logoImageView = {
        let result = UIImageView(image: .init(named: "logo"))
        result.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            result.widthAnchor.constraint(equalTo: result.heightAnchor, multiplier: 1),
            result.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
        result.contentMode = .scaleAspectFit
        
        return result
    }()
    
    let sibsutiesLabel: UILabel = {
        let result = UILabel()
        result.text = "СибУтки"
        result.font = .preferredFont(forTextStyle: .largeTitle)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.adjustsFontForContentSizeCategory = true

        return result
    }()
    
    let groupButton: UIButton = {
        let result = UIButton()
        result.setTitle("Выбор Группы", for: .normal)
        result.titleLabel?.font = .preferredFont(forTextStyle: .body)
        result.titleLabel?.adjustsFontForContentSizeCategory = true

        result.translatesAutoresizingMaskIntoConstraints = false
        result.setTitleColor(.systemYellow, for: .normal)
        
        result.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        result.titleLabel?.adjustsFontForContentSizeCategory = true

        result.layer.cornerRadius = result.bounds.height/2
        result.layer.borderWidth = 2
        result.clipsToBounds = true

        return result
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        groupButton.layer.cornerRadius = groupButton.bounds.height/2
        let color = (traitCollection.userInterfaceStyle == .light) ? UIColor.systemBlue : UIColor.systemYellow
        groupButton.setTitleColor(color, for: .normal)
        groupButton.layer.borderColor = color.cgColor
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(sibsutiesLabel)
        contentView.addSubview(groupButton)
        
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            // логотип
            logoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            // надпись
            sibsutiesLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            sibsutiesLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            // кнопка
            groupButton.leadingAnchor.constraint(greaterThanOrEqualTo: sibsutiesLabel.trailingAnchor, constant: 12),
            groupButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            groupButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
        groupButton.layer.cornerRadius = groupButton.bounds.height/2
        groupButton.addTarget(self, action: #selector(taped), for: .touchUpInside)
    }
    
    @objc func taped() {
        delegate.showModal()
    }
    
    
    //MARK: - Наполнение группой -
    func configure(string: String) {
        groupButton.setTitle(string, for: .normal)
        groupButton.layoutIfNeeded()
    }
    
}
