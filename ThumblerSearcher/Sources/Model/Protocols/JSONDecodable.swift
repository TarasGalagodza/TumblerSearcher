//
//  JSONDecodable.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import Foundation

protocol JSONDecodable {
    associatedtype DecodableType
    static func decode(json: Any) -> DecodableType?
    static func decode(json: Any?) -> DecodableType?
}

extension JSONDecodable {
    static func decode(json: Any?) -> DecodableType? {
        guard let json = json else { return nil }
        return decode(json: json)
    }
}
