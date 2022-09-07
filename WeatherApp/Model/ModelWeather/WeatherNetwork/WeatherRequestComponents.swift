//
//  WeatherBroadcastRequest.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 11.08.2022.
//

import Foundation

class WeatherForecast: Codable {
    
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let dt: Int
    let sys: Sys
    
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }

    struct Sys: Codable {
        let sunrise, sunset: Int
    }

    struct Weather: Codable {
        let main, weatherDescription, icon: String
        
        enum CodingKeys: String, CodingKey {
            case main
            case weatherDescription = "description"
            case icon
        }
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}

struct WeatherAPIComponents: APIComponents {
    
    static let shared = WeatherAPIComponents()

    let accessKey = "f7c776d15a5d00f5909f77d3ab056131"

    let urlString = "https://api.openweathermap.org/data/2.5/weather?"
    
    func URL(configuration config: [URL.ConfigurationKeys: Any]) -> URL? {
        guard let coordinates = config[.coordinates] as? Coordinates,
              let unit = config[.unit] as? Unit
        else { return nil }
        let lon = coordinates.longitude
        let lat = coordinates.latitude
        let url = Foundation.URL(
            string: "\(urlString)lat=\(lat)&lon=\(lon)&units=\(unit)&appid=\(accessKey)")
        return url
    }

    enum Unit: String {
        case metric = "metric"
        case imperial = "imperial"
    }
    
    private init() {}
    
}
