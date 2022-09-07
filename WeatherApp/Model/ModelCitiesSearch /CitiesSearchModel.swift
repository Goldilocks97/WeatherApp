//
//  CitiesModel.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 29.08.2022.
//

import Foundation


struct CitiesSearchModel {
    
    typealias Handler = ([String]) -> Void
    
    lazy var citiesSearchingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Cities searching"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    var pendingOperation: Operation?
    
    mutating func findCities(input: String, handler: @escaping Handler) {
        if let op = pendingOperation {
            op.cancel()
        }
        let operation = CitiesSearcher(input: input, handler: handler)
        pendingOperation = operation
        citiesSearchingQueue.addOperation(operation)
    }
    
}
