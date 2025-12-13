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
    private let viewModel: CitySearchViewModel
    weak var coordinator: WeatherCoordinator?

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CitySearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("CitySearchViewController must be created programmatically")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupSearchBar()
        setupStarButton()
        bindViewModel()
    }

    private func setupStarButton() {
        let starButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoritesButtonTapped)
        )
        navigationItem.rightBarButtonItem = starButton
    }

    @objc private func favoritesButtonTapped() {
        coordinator?.showFavorites()
    }

    private func setupSearchBar() {
        mainView.searchBar.delegate = self
    }

    private func setDelegates() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
    }

    private func bindViewModel() {
        viewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let city = viewModel.results[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

        let isFavorite = viewModel.favorites.contains { $0.lat == city.lat && $0.lon == city.lon }
        cell.configure(with: "\(city.name), \(city.state ?? ""), \(city.country)", isFavorite: isFavorite)
        cell.starTapped = { [weak self] in
            guard let self = self else { return }
            if isFavorite {
                self.viewModel.removeFromFavorites(city)
            } else {
                self.viewModel.addToFavorites(city)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.results[indexPath.row]
        coordinator?.showWeather(for: city)
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}
