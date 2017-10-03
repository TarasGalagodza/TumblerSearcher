//
//  PhotoListing.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import Foundation

class PhotoListing {
    static var empty: PhotoListing = PhotoListing(entities: [])

    let entities: [PhotoPostEntity]
    var lastEntityTimestamp: Int {
        get {
            var timestamp = 0
            if let lastEntity = self.entities.last {
                timestamp = lastEntity.timestamp
            }
            return timestamp
        }
    }
    var isEmpty: Bool {
        return self.entities.isEmpty
    }

    init(entities: [PhotoPostEntity]) {
        self.entities = entities
    }
    
    static func +(left: PhotoListing, right: PhotoListing) -> PhotoListing {
        let entities = left.entities + right.entities
        return PhotoListing(entities: entities)
    }
}

extension PhotoListing: JSONDecodable {
    static func decode(json: Any) -> PhotoListing? {
        guard let dataDictionary = json as? [String: Any],
            let meta = dataDictionary["meta"] as? [String: Any],
            let status = meta["status"] as? Int
            else { return nil }
        
        if (status != 200) {
            //handle error
            return nil;
        }
        else {
            var entities = [PhotoPostEntity]()
            if let response = dataDictionary["response"] as? [Any] {
                for entity in response {
                    if let post = PhotoPostEntity.decode(json: entity) {
                        entities.append(post)
                    }
                }
            }
            
            return PhotoListing(entities: entities)
        }
    }
}
