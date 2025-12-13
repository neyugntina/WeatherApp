//
//  WeatherDetailView.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/12/25.
//

import UIKit

class WeatherDetailView: UIView {
    let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tempLabel.font = .systemFont(ofSize: 32, weight: .bold)
               tempLabel.textAlignment = .center

               addSubview(tempLabel)
               tempLabel.translatesAutoresizingMaskIntoConstraints = false

               NSLayoutConstraint.activate([
                   tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                   tempLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
               ])
    }
}
