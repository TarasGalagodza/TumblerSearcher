//
//  RequestManager.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import UIKit

class RequestManager {

    static let sharedInstance = RequestManager()
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private lazy var requests: Array<Request> = [Request]()
    
    func send(request: Request, completionHandler: @escaping(Any?, NetworkError?) -> Void) {
        request.cancelRequest()
        requests.append(request)
        
        request.failureBlock = {[weak self] (error: NetworkError?)->() in
            completionHandler(nil, error)
            if let index = self?.requests.index(of: request) {
                self?.requests.remove(at: index)
            }
        }
        request.successBlock = {[weak self] (object: Any?)->() in
            completionHandler(object, nil)
            if let index = self?.requests.index(of: request) {
                self?.requests.remove(at: index)
            }
        }
        request.sendRequestWith(session: session)
    }
}
