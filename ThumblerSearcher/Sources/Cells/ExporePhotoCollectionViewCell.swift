//
//  ExporePhotoCollectionViewCell.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/3/17.
//

import UIKit

class ExporePhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    fileprivate static let sizeToFit : CGFloat = 300.0

    var post: PhotoPostEntity? {
        didSet {
            thumbnailImageView?.image = UIImage.init(named: "no-pictures-available_icon")
            if let post = post {
                var fittedPhotoMetaInfo = post.originalPhotoMetaInfo
                for (_, element) in post.alternativePhotosMetaInfo.enumerated() {
                    if (fittedPhotoMetaInfo.photoSize.width > element.photoSize.width &&
                        ExporePhotoCollectionViewCell.sizeToFit < element.photoSize.width)
                    {
                        fittedPhotoMetaInfo = element
                    }
                }

                thumbnailImageView.downloadedFrom(link: fittedPhotoMetaInfo.photoURLString);
            }
        }
    }
}
