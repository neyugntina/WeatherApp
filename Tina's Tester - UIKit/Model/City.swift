//
//  CityCoordinateModel.swift
//  Tina's Tester - UIKit
//
//  Created by Tina Nguyen on 12/9/25.
//

struct City: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
