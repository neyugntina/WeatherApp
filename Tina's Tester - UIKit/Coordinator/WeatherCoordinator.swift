//
//  WeatherCoordinator.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/12/25.
//

import Combine
import UIKit

final class WeatherCoordinator {

    let navigationController: UINavigationController
    let viewModel = CitySearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let cityVC = CitySearchViewController(viewModel: viewModel)
        cityVC.coordinator = self
        navigationController.pushViewController(cityVC, animated: false)
    }

    func showFavorites() {
        let favoritesVC = FavoritesListViewController(viewModel: viewModel)
        favoritesVC.coordinator = self
        navigationController.pushViewController(favoritesVC, animated: true)
    }

    func showWeather(for city: City) {
        viewModel.searchWeatherByLocation(lat: city.lat, lon: city.lon)

        viewModel.$weather
            .compactMap { $0 }
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                let vc = WeatherDetailViewController()
                vc.weather = weather
                self?.navigationController.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}
