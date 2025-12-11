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

        let cityVC = CitySearchViewController()
        let navController = UINavigationController(rootViewController: cityVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }


}

