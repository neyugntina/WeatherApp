//
//  CitySearchViewController.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//

import UIKit
import Combine

class CitySearchViewController: UIViewController {
    
    private let mainView = CitySearchView()
    private let viewModel = CitySearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.searchCity(city: "London")
    }
    
    private func setDelegates() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.searchBar.delegate = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    private func bindViewModel() {
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { error in
                if let error = error {
                    print("Error:", error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = viewModel.cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(city.name), \(city.state ?? ""), \(city.country)"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitySearchViewController: UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.cities[indexPath.row]
        viewModel.searchWeatherByLocation(lat: city.lat, lon: city.lon)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCity(city: searchText)
    }
}
