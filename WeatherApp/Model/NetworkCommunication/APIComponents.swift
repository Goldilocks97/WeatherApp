//
//  APIKeys.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 18.08.2022.
//

import Foundation

protocol APIComponents {
    
    var accessKey: String { get }
    var urlString: String { get }
    
    func URL(configuration config: [URL.ConfigurationKeys: Any]) -> URL?
    
}
