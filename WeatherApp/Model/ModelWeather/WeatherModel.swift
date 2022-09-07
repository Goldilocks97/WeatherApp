//
//  Model.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 11.08.2022.
//

import Foundation


class WeatherModel {

    typealias Handler = (WeatherForecast) -> Void
    
    private var cacheForecasts = NSCache<NSString, WeatherForecast>()
    private var cacheCoordinates = NSCache<NSString, Coordinates>()
    
    private var tasksForecasts = [String: URLSessionTask]()
    private var tasksCities = [String: URLSessionTask]()
    private var handlers = [String: [Handler]]()

    private let weatherRequestComponents = WeatherAPIComponents.shared
    private let geoCityRequsetComponents = GeoCityAPIComponents.shared
    private let constants = WeatherModelConstants.shared
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKeys = UserDefaultsKeys.shared

    
    private let downloader: Downloader = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsExpensiveNetworkAccess = false
        return Downloader(configuration: config)
    }()

    var cities = [String]()
    
    init() {
        guard
            let _ = userDefaults.object(forKey: userDefaultsKeys.isFirstLaunch),
            let cities = retrieveCitiesFromUserDefaults()
        else {
            let cities = constants.citiesStandardPack
            self.cities = cities
            return
        }
        self.cities = cities
    }

    // MARK: - API
    func forecast(for city: String, handler: @escaping Handler) {
        addForecastHandler(city: city, handler: handler)
        if let forecast = cacheForecasts.object(forKey: city as NSString)
        {
            handler(forecast)
            return
        }
        if tasksForecasts[city] != nil {
            return
        }
        let unit = WeatherAPIComponents.Unit.metric
        if let coordinates = cacheCoordinates.object(forKey: city as NSString) {
            downloadForecast(with: [.city: city, .unit: unit, .coordinates: coordinates])
        } else {
            downloadCoordinates(with: [.city: city, .unit: unit]) {
                [weak self] (coordinates) in
                self?.downloadForecast(with: [.city: city, .unit: unit, .coordinates: coordinates])
            }
        }
    }
    
    func saveCities() {
        saveCitiesInUserDefaults()
    }
    
    func removeCity(_ name: String) {
        cities.removeFirst { $0 == name }
    }

    // MARK: - Private methods
    private func saveCitiesInUserDefaults() {
        do {
            let dataEncoded = try PropertyListEncoder().encode(cities)
            userDefaults.set(dataEncoded, forKey: userDefaultsKeys.cities)
            userDefaults.set(false, forKey: userDefaultsKeys.isFirstLaunch)
        } catch {
            print("Error. Cannot save cities.")
        }
    }

    private func retrieveCitiesFromUserDefaults() -> [String]? {
        guard let data = userDefaults.object(forKey: userDefaultsKeys.cities) as? Data
        else { return nil }
        do {
            let cities = try PropertyListDecoder().decode([String].self, from: data)
            return cities
        } catch {
            print("Error. Cannot retrieve cities.")
            return nil
        }
    }

    private func downloadForecast(with config: [URL.ConfigurationKeys: Any])
    {
        guard
            let url = weatherRequestComponents.URL(configuration: config),
            let city = config[.city] as? String
        else { return }
        let task = downloader.dowload(url: url) { [weak self] (data) in
            self?.tasksForecasts[city] = nil
            let decoder = JSONDecoder()
            do {
                let forecast = try decoder.decode(WeatherForecast.self, from: data)
                self?.cacheForecasts.setObject(forecast, forKey: city as NSString)
                guard let handlers = self?.handlers[city] else { return }
                handlers.forEach { $0(forecast) }
            } catch {
                print("Error. Cannot parse broadcast...")
            }
        }
        tasksForecasts[city] = task
    }

    private func downloadCoordinates(
        with config: [URL.ConfigurationKeys: Any],
        handler: @escaping (Coordinates) -> Void)
    {
        guard
            let city = config[.city] as? String,
            let url = geoCityRequsetComponents.URL(configuration: config)
        else { return }
        let task = downloader.dowload(url: url) { [weak self] (data) in
            self?.tasksCities[city] = nil
            let decoder = JSONDecoder()
            do {
                let geoCity = try decoder.decode(GeoCity.self, from: data)
                self?.cacheCoordinates.setObject(
                    geoCity.coordinates,
                    forKey: city as NSString)
                handler(geoCity.coordinates)
            } catch {
                print("Error. Cannot parse coordinates...")
            }
        }
        tasksCities[city] = task
    }

    private func addForecastHandler(city: String, handler: @escaping Handler) {
        if handlers[city] != nil {
            handlers[city]?.append(handler)
        } else {
            handlers[city] = [handler]
        }
    }
    
//  func saveBroadcastsBeforeTerminated(_ broadcasts: [String: WeatherForecast]) {
//        let fileManager = FileManager()
//        do {
//            let dir = try fileManager.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: false)
//            let url = dir.appendingPathComponent(constants.directoryToSaveBroadcastsBeforeTerminated)
//            print(url)
//            let archivedData = try PropertyListEncoder().encode(broadcasts)
//            try archivedData.write(to: url, options: .atomic)
//        } catch {
//            print("Error. Cannot find url to save")
//        }
//    }
}


extension Array {
    mutating func removeFirst(condition: ((Element) -> Bool)) {
        for (index, element) in self.enumerated() {
            if condition(element) {
                remove(at: index)
            }
        }
    }
}
