//
//  CitySearchViewModel.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//

import Combine
import CoreData
import Foundation

final class CitySearchViewModel {
    private let apiService: WeatherAPIServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var weather: WeatherModel?
    @Published var results: [City] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    var favorites: [City] = []

    private let context = PersistenceController.shared.context
    
    init(apiService: WeatherAPIServiceProtocol = WeatherAPIService()) {
        self.apiService = apiService
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query)
            }
            .store(in: &cancellables)
    }
    
    private func search(_ query: String) {
        guard !query.isEmpty else {
            self.results = []
            return
        }
        
        apiService.fetchCityCoordinates(cityName: query)
            .map { cities in
                cities.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] filteredCities in
                self?.results = filteredCities
            }
            .store(in: &cancellables)
    }
    
    func searchWeatherByLocation(lat: Double, lon: Double) {
        apiService.fetchWeatherByCity(lat: lat, lon: lon)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weathers in
                self?.weather = weathers
            }
            .store(in: &cancellables)
    }
    
// MARK: - Favorites Persistence
    
    func fetchFavorites() -> [City] {
        let request: NSFetchRequest<FavoriteCities> = FavoriteCities.fetchRequest()
        
        do {
            let savedFavorites = try context.fetch(request)
            // Map to your City model
            let cities = savedFavorites.map { favorite in
                City(
                    name: favorite.name ?? "",
                    lat: favorite.lat,
                    lon: favorite.lon,
                    country: favorite.country ?? "",
                    state: favorite.state
                )
            }
            self.favorites = cities
            return cities
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }


    func addToFavorites(_ city: City) {
        // check if exists
        let request: NSFetchRequest<FavoriteCities> = FavoriteCities.fetchRequest()
        request.predicate = NSPredicate(
            format: "lat == %lf AND lon == %lf",
            city.lat,
            city.lon
        )
        if let existing = try? context.fetch(request), !existing.isEmpty {
            return
        }
        
        let favorite = FavoriteCities(context: context)
        favorite.name = city.name
        favorite.state = city.state
        favorite.country = city.country
        favorite.lat = city.lat
        favorite.lon = city.lon
        
        saveContext()

        if !favorites.contains(where: { $0.name == city.name && $0.country == city.country }) {
            favorites.append(city)
        }
    }

    func removeFromFavorites(_ city: City) {
        let request: NSFetchRequest<FavoriteCities> = FavoriteCities.fetchRequest()
        request.predicate = NSPredicate(
            format: "lat == %lf AND lon == %lf",
            city.lat,
            city.lon
        )
        
        if let existing = try? context.fetch(request) {
            for obj in existing {
                context.delete(obj)
            }
            saveContext()

            favorites.removeAll { $0.name == city.name && $0.country == city.country }
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
