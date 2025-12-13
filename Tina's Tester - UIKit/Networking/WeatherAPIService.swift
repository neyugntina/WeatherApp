//
//  WeatherAPIService.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//

import Foundation
import Combine

protocol WeatherAPIServiceProtocol {
    func fetchCityCoordinates(cityName: String) -> AnyPublisher<[City], Error>
    func fetchWeatherByCity(lat: Double, lon: Double) -> AnyPublisher<WeatherModel, Error>
}

final class WeatherAPIService: WeatherAPIServiceProtocol {
    
    private let apiKey = ""
    private let baseURL = "https://api.openweathermap.org/geo/1.0/direct"
    private let getWeatherURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchCityCoordinates(cityName: String) -> AnyPublisher<[City], Error> {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [City].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherByCity(lat: Double, lon: Double) -> AnyPublisher<WeatherModel, Error> {
        var components = URLComponents(string: getWeatherURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
