//
//  Coordinate.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 18.08.2022.
//

import Foundation

class Coordinates: Codable {

    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}
