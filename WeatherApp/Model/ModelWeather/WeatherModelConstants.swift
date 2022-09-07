//
//  WeatherModelConstants.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 18.08.2022.
//

import Foundation

struct WeatherModelConstants {
    
    static let shared = WeatherModelConstants()

    let citiesStandardPack = [
        "Barcelona",
        "Moscow",
        "Prague",
        "Paris",
        "London",
        "Berlin",
        "Canberra"]
    
    let directoryToSaveBroadcastsBeforeTerminated = "SavedCities"
    
    private init() {}
}
