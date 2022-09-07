//
//  CitiesSearchRequestComponents.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 20.08.2022.
//

import Foundation


struct FoundCities: Codable {
    
    let cities: [String]
    let status: String
    
    init(from decoder: Decoder) throws {
        let con = try decoder.container(keyedBy: CodingKeys.self)
        let pred = try con.decode([Prediction].self, forKey: .cities)
        let cities = pred.map {$0.structuredFormatting.mainText}
        self.cities = cities
        self.status = try con.decode(String.self, forKey: .status)
    }
    
    enum CodingKeys: String, CodingKey {
        case cities = "predictions"
        case status
    }

    struct Prediction: Codable {
        let name: String
        let structuredFormatting: StructuredFormatting

        enum CodingKeys: String, CodingKey {
            case name = "description"
            case structuredFormatting = "structured_formatting"
        }
    }
    
    struct StructuredFormatting: Codable {
        let mainText: String

        enum CodingKeys: String, CodingKey {
            case mainText = "main_text"
        }
    }
}

struct CitiesSearchRequestComponents: APIComponents {
    
    static let shared = CitiesSearchRequestComponents()

    let accessKey = "AIzaSyB8t8WG4CetIDD9jYQDu43D9U1m4vDRNAo"
    
    let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    
    func URL(configuration config: [URL.ConfigurationKeys : Any]) -> URL? {
        guard let input = config[.input] as? String else { return nil }
        return Foundation.URL(string: urlString + "input=\(input)" + "&key=\(accessKey)")
    }
    
    private init() {}
}
