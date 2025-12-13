//
//  WeatherDetailViewController.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/12/25.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    let mainView = WeatherDetailView()
    var weather: WeatherModel?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weather = weather {
            let tempF = formatTemp(weather.main.temp)
            mainView.tempLabel.text = tempF
        }
    }
    
    private func formatTemp(_ kelvin: Double) -> String {
        let f = (kelvin - 273.15) * 9/5 + 32
        return String(format: "%.1f°F", f)
    }
}
