//
//  FavoritesListViewController.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/12/25.
//

import UIKit

class FavoritesListViewController: UIViewController {

    var viewModel: CitySearchViewModel
    weak var coordinator: WeatherCoordinator?

    let tableView = UITableView()

    init(viewModel: CitySearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("FavoritesListViewController must be created programmatically")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
        tableView.reloadData()
    }
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = viewModel.favorites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(city.name), \(city.state ?? ""), \(city.country)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.favorites[indexPath.row]
        coordinator?.showWeather(for: city)
    }
}

