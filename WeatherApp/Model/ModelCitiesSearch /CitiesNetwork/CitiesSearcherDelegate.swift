//
//  CitiesSearcherDelegate.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 21.08.2022.
//

import UIKit

protocol CitiesSearcherDelegate: AnyObject {
    func recieveFoundCities(_ cities: [String])
}
