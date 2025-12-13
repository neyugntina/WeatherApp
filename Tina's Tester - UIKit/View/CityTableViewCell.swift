//
//  CityTableViewCell.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/12/25.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"
    
    let nameLabel = UILabel()
    let starButton = UIButton(type: .system)
    
    var starTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(starButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            starButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
    }
    
    @objc private func didTapStar() {
        starTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cityName: String, isFavorite: Bool) {
        nameLabel.text = cityName
        let imageName = isFavorite ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
