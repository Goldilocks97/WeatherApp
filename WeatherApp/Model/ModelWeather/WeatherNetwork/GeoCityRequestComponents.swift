//
//  CityRequestComponents.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 15.08.2022.
//

import Foundation

struct GeoCity: Codable {

    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "results"
    }
    
    init(from decoder: Decoder) throws {
        let con = try decoder.container(keyedBy: CodingKeys.self)
        let res = try con.decode([Result].self, forKey: .coordinates)
        let latitude = res.first!.geometry.location.lat // force unwrapping. It doesn't work in some places.
        let longitude = res.first!.geometry.location.lng
        self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
    }

    private struct Result: Codable {
        let geometry: Geometry
    }

    private struct Geometry: Codable {
        let location: Location
    }

    private struct Location: Codable {
        let lat, lng: Double
    }
    
}

    
struct GeoCityAPIComponents: APIComponents {
    
    static let shared = GeoCityAPIComponents()

    let accessKey = "AIzaSyB8t8WG4CetIDD9jYQDu43D9U1m4vDRNAo"

    let urlString = "https://maps.googleapis.com/maps/api/geocode/json?"

    func URL(configuration config: [URL.ConfigurationKeys: Any]) -> URL? {
        guard let city = (config[.city] as? String) else { return nil }
        return Foundation.URL(string: "\(urlString)address=\(city)&key=\(accessKey)")
    }
    
    private init() {}
}
