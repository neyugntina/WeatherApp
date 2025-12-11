//
//  CitySearchView.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//
import UIKit

class CitySearchView: UIView {
    let tableView = UITableView()
    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpTableView()
        setUpSearchBar()
    }
    
    private func setUpTableView() {
        addSubview(tableView)
        tableView.frame = bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setUpSearchBar() {
        searchBar.placeholder = "Search City"
        searchBar.autocapitalizationType = .none
        tableView.tableHeaderView  = searchBar
        searchBar.sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
