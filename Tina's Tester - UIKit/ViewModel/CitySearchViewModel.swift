//
//  CitySearchViewModel.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//

import Foundation
import Combine

final class CitySearchViewModel {
    private let apiService: WeatherAPIServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var weather: [WeatherModel] = []
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    
    init(apiService: WeatherAPIServiceProtocol = WeatherAPIService()) {
        self.apiService = apiService
    }
    
    func searchCity(city: String) {
        apiService.fetchCityCoordinates(cityName: city)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] cities in
                self?.cities = cities
            }
            .store(in: &cancellables)
    }
    
    func searchWeatherByLocation(lat: Double, lon: Double) {
        apiService.fetchWeatherByCity(lat: lat, lon: lon)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weathers in
                self?.weather = weathers
            }
            .store(in: &cancellables)
    }
}
