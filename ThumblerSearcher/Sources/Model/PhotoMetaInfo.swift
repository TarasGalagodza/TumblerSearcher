//
//  PhotoMetaInfo.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/3/17.
//

import UIKit

class PhotoMetaInfo {
    let photoURLString : String
    let photoSize : CGSize
    
    static var empty: PhotoMetaInfo = PhotoMetaInfo(photoURLString: "", photoSize: CGSize(width: 0, height: 0))

    init(photoURLString: String, photoSize: CGSize) {
        self.photoURLString = photoURLString
        self.photoSize = photoSize
    }
}

extension PhotoMetaInfo: JSONDecodable {
    static func decode(json: Any) -> PhotoMetaInfo? {
        guard let dataDictionary = json as? [String: Any]
            else { return nil }
        
        let width = dataDictionary["width"] as? CGFloat ?? 0
        let height = dataDictionary["height"] as? CGFloat ?? 0
        let size = CGSize(width: width, height: height)
        let photoURL = dataDictionary["url"] as? String ?? ""
        
        return PhotoMetaInfo(photoURLString: photoURL, photoSize: size)
    }
}
