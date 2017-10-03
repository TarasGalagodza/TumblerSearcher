//
//  PhotoEntity.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import UIKit

class PhotoPostEntity {
    let timestamp : Int
    let originalPhotoMetaInfo: PhotoMetaInfo
    let alternativePhotosMetaInfo: [PhotoMetaInfo]

    init(originalPhotoMetaInfo: PhotoMetaInfo, alternativePhotosMetaInfo: [PhotoMetaInfo], timestamp: Int) {
        self.originalPhotoMetaInfo = originalPhotoMetaInfo
        self.alternativePhotosMetaInfo = alternativePhotosMetaInfo
        self.timestamp = timestamp
    }
}

extension PhotoPostEntity: JSONDecodable {
    static func decode(json: Any) -> PhotoPostEntity? {
        guard let dataDictionary = json as? [String: Any],
            let photos = dataDictionary["photos"] as? [[String: Any]]
            else { return nil }
        
        var timestamp = dataDictionary["timestamp"] as? Int ?? 0
        if let featuredTimestamp = dataDictionary["featured_timestamp"] as? Int {
            timestamp = featuredTimestamp
        }
        
        var originalPhotoMetaDictionary : [String: Any] = [String: Any]()
        var alternativePhotosMetaInfo = [PhotoMetaInfo]()
        if let firstPhoto = photos.first {
            originalPhotoMetaDictionary = firstPhoto["original_size"] as? [String : Any] ?? [String: Any]()
            let altPhotosData = firstPhoto["alt_sizes"] as? [[String: Any]] ?? [[String: Any]]()
            for entity in altPhotosData {
                if let photoMeta = PhotoMetaInfo.decode(json: entity) {
                    alternativePhotosMetaInfo.append(photoMeta)
                }
            }
        }
        
        var originalPhotoMeta = PhotoMetaInfo.empty
        if let decodedOriginalPhotoMeta = PhotoMetaInfo.decode(json: originalPhotoMetaDictionary) {
            originalPhotoMeta = decodedOriginalPhotoMeta
        }

        return PhotoPostEntity(originalPhotoMetaInfo: originalPhotoMeta, alternativePhotosMetaInfo: alternativePhotosMetaInfo, timestamp: timestamp)
    }
}
