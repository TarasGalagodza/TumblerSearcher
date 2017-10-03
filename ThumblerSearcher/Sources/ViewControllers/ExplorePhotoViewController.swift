//
//  ViewController.swift
//  ThumblerSearcher
//
//  Created by Taras Galagodza on 10/2/17.
//

import UIKit

class ExplorePhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var enterSearchStringLabel: UILabel!

    fileprivate static let cellWidth : CGFloat = 100.0
    
    fileprivate var listing: PhotoListing = PhotoListing.empty
    private var isLoadingInProgress: Bool = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoadingInProgress
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if (identifier == "showFullSizeImageSegue"),
                let indexPath = sender as? IndexPath {
                let imageViewController = segue.destination as! FullSizePhotoViewController
                imageViewController.post = listing.entities[indexPath.item]
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listing.entities.isEmpty {
            loadMorePosts()
        }
    }
    
    fileprivate func loadMorePosts(reloadList: Bool = false) {
        guard !isLoadingInProgress else {
            return;
        }
        
        isLoadingInProgress = true
        var searchTerm = ""
        if let text = self.searchBar.text {
            searchTerm = text
        }
        let request = SearchPhotoRequest(searchString: searchTerm, before: listing.lastEntityTimestamp)
        RequestManager.sharedInstance.send(request: request, completionHandler: {[weak self] loadedListing, error in
            self?.isLoadingInProgress = false
            if let error = error {
                self?.handleNetworkError(error);
            }
            else {
                if (reloadList) {
                    self?.listing = PhotoListing.empty
                }

                if let loadedListing = loadedListing as? PhotoListing, let listing = self?.listing {
                    self?.listing = listing + loadedListing
                    self?.collectionView.reloadData()
                }
            }
        });
    }
    
    fileprivate func handleNetworkError(_: NetworkError) {
    }
}

extension ExplorePhotoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            self.enterSearchStringLabel.isHidden = !text.isEmpty
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadMorePosts(reloadList: true)
        self.searchBar.resignFirstResponder()
    }
}

extension ExplorePhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return self.listing.entities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "explorePhotoCellIdentifier", for: indexPath) as! ExporePhotoCollectionViewCell
        cell.post = listing.entities[indexPath.item]

        return cell
    }
}

extension ExplorePhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFullSizeImageSegue", sender: indexPath)
    }
    
}

extension ExplorePhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let post = listing.entities[indexPath.item]
        var fittedPhotoMetaInfo : PhotoMetaInfo = post.originalPhotoMetaInfo
        for (_, element) in post.alternativePhotosMetaInfo.enumerated() {
            if (fittedPhotoMetaInfo.photoSize.width > element.photoSize.width &&
                ExplorePhotoViewController.cellWidth < element.photoSize.width)
            {
                fittedPhotoMetaInfo = element
            }
        }

        let height = fittedPhotoMetaInfo.photoSize.height * ExplorePhotoViewController.cellWidth / fittedPhotoMetaInfo.photoSize.width
        
        return CGSize(width: ExplorePhotoViewController.cellWidth, height: height)
    }
    
}

