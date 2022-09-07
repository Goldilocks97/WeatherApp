//
//  CitiesSearcher.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 20.08.2022.
//

import Foundation

class CitiesSearcher: Operation {
    
    typealias Handler = ([String]) -> Void
    
    let input: String

    let requestComponents = CitiesSearchRequestComponents.shared
    
    var handler: Handler
    
    private let downloader: Downloader = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsExpensiveNetworkAccess = false
        return Downloader(configuration: config)
    }()
    
    init(input: String, handler: @escaping Handler) {
        self.input = input
        self.handler = handler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        guard let url = requestComponents.URL(configuration: [.input: input]) else { return }
        let _ = downloader.dowload(url: url) { [weak self] (data) in
            guard
                self != nil,
                !self!.isCancelled
            else { return }
            do {
                let uncoded = try JSONDecoder().decode(FoundCities.self, from: data)
                var set = Set<String>()
                uncoded.cities.forEach {
                    if let city = $0.components(separatedBy: " ").first {
                        set.insert(city)
                    }
                }
                DispatchQueue.main.async {
                    self?.handler(Array(set))
                }
            } catch {
                print("Oooops. I cannot parse it...")
            }
        }
    }
}
