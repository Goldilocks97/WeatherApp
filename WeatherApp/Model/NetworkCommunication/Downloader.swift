//
//  Downloader.swift
//  WeatherAppIntern
//
//  Created by Ivan Pavlov on 12.08.2022.
//

import Foundation

typealias DownloaderCH = (Data) -> () // Where to place?

class Downloader {

    private let config: URLSessionConfiguration

    private lazy var session: URLSession = {
        return URLSession(
            configuration: config,
            delegate: DownloaderDelegate(),
            delegateQueue: .current) //main???
    }()
    
    init(configuration config: URLSessionConfiguration) {
        self.config = config
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    func dowload(url: URL, completionHandler ch: @escaping DownloaderCH) -> URLSessionTask {
        let task = session.dataTask(with: url)
        (session.delegate as! DownloaderDelegate).appendHandler(ch, for: task) //force unwrapping?
        task.resume()
        return task
    }

}


class DownloaderDelegate: NSObject, URLSessionDataDelegate {
    
    private var data = [Int:Data]()
    
    private var handlers = [Int: DownloaderCH]()
    
    func appendHandler(_ ch: @escaping DownloaderCH, for task: URLSessionTask) {
        handlers[task.taskIdentifier] = ch
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data)
    {
        if self.data[dataTask.taskIdentifier] != nil {
            self.data[dataTask.taskIdentifier]!.append(contentsOf: data) //force unwrapping?
        } else {
            self.data[dataTask.taskIdentifier] = data
        }
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?)
    {
        guard error == nil else { return }
        let data = self.data[task.taskIdentifier]! //force unwrapping??
        self.data.removeValue(forKey: task.taskIdentifier)
        let handler = handlers[task.taskIdentifier]!
        handlers.removeValue(forKey: task.taskIdentifier)
        handler(data)
    }
    
}
