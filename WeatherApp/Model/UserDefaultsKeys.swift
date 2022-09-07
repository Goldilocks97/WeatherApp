//
//  UserDefaultsKeys.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 18.08.2022.
//

import Foundation

struct UserDefaultsKeys {
    
    static let shared = UserDefaultsKeys()
    
    let cities = "cities"
    let isFirstLaunch = "isFirstLaunch"
    
    private init() {}
}
