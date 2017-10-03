//
//  Request.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import UIKit

typealias RequestFailureBlock = (NetworkError?)-> Void
typealias RequestSuccessBlock = (Any?)-> Void

enum NetworkError: Error {
    case systemError
    case wrongResponseFormat
    case failedToParseResponse
}

class Request: NSObject {
    static let baseURL = "http://api.tumblr.com/v2/"
    private var url : URL
    private var dataTask : URLSessionDataTask?
    var successBlock : RequestSuccessBlock?
    var failureBlock : RequestFailureBlock?
    
    init(url: URL){
        self.url = url
    }
    
    func cancelRequest() {
        if let dataTask = dataTask {
            dataTask.cancel()
        }
    }
    
    func sendRequestWith(session: URLSession) {
        
        let request = URLRequest(url: url)
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            
            var networkError: NetworkError? = nil
            defer {
                if let networkError = networkError, let failureBlock = self?.failureBlock {
                    DispatchQueue.main.async {
                        failureBlock(networkError)
                    }
                }
            }
            
            if error != nil {
                networkError = .systemError
                return
            }
            
            guard let data = data else {
                networkError = .wrongResponseFormat
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let parseResult = self?.parse(json: json)
                {
                    DispatchQueue.main.async {
                        if let successBlock = self?.successBlock {
                            DispatchQueue.main.async {
                                successBlock(parseResult)
                            }
                        }
                    }
                }
                else {
                    networkError = .failedToParseResponse
                }
            } catch {
                networkError = .failedToParseResponse
            }
        }
        dataTask?.resume()
    }
    
    func parse(json: Any) -> Any? {
        return nil
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return
            lhs.url == rhs.url
    }
}
