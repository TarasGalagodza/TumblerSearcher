//
//  SearchPhotoRequest.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import UIKit

class SearchPhotoRequest: Request {
    
    init(searchString: String = "", before: Int = 0) {
        var url: URL?
        if var urlComponents = URLComponents(string:(Request.baseURL + "tagged?")) {
            var items = [URLQueryItem]()
            items.append(URLQueryItem(name: "tag", value: searchString))
            items.append(URLQueryItem(name: "api_key", value: "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U"))
            urlComponents.queryItems = items
            url = urlComponents.url
        } else {
            assertionFailure("failed to create top post URL")
        }
        
        super.init(url: url!)
    }
    
    override func parse(json: Any) -> Any? {
        return PhotoListing.decode(json: json);
    }
}
