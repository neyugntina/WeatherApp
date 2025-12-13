//
//  ViewController.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/8/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let navController = UINavigationController()
        let coordinator = WeatherCoordinator(navigationController: navController)
        coordinator.start()

        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

