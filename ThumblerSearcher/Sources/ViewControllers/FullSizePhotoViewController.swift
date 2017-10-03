//
//  FullSizePhotoViewController.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/3/17.
//

import UIKit

class FullSizePhotoViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!

    var post: PhotoPostEntity?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let post = post {
            self.thumbnailImageView.downloadedFrom(link: post.originalPhotoMetaInfo.photoURLString)
        }
    }

}
