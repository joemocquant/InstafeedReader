//
//  FeedViewController.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 7/6/15.
//  Copyright (c) 2015 InstafeedReader. All rights reserved.
//

import UIKit
import InstagramKit
import AFNetworking


class FeedViewController: UIViewController, UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDelegateFlowLayout,
                                            UIScrollViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadingNewPage: Bool = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loadingNewPage
        }
    }
    
    //Computing properties only once
    let widthRes: CGFloat = FeedViewController.widthRes
    let heightRes: CGFloat = FeedViewController.heightRes
    let numColumns: Int = FeedViewController.numColumns
    let cellSize: CGSize = FeedViewController.cellSize
    let cellsPerPageCount: Int = FeedViewController.cellsPerPageCount
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {

        title = ItemsCollection.sharedInstance.instagramUser.username
        navigationItem.hidesBackButton = true
        
        loadNewPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.userInteractionEnabled = true
        
        if let indexPaths = collectionView.indexPathsForSelectedItems() {
            
            if (indexPaths.count != 0) {
                if let cell = collectionView.cellForItemAtIndexPath(indexPaths[0]) {
                    cell.alpha = 1.0
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        collectionView.userInteractionEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ItemsCollection.sharedInstance.removeAll()
        collectionView.reloadData()
        loadNewPage()
    }
    
    
    // MARK: - Private Methods
    
    private func shouldLoadNewPage() -> Bool {
        
        if (ItemsCollection.sharedInstance.endReached) {
            return false
        }
        
        let yOffset = collectionView.contentOffset.y;
        let height = collectionView.contentSize.height - CGRectGetHeight(collectionView.frame);
        
        if (yOffset >= height - cellSize.height) {
            return true
        }
        
        return false
    }
    
    private func loadNewPage() {
        
        loadingNewPage = true
        
        ItemsCollection.sharedInstance.retrieveNewItems(cellsPerPageCount, successBlock: { indexPaths in
            
                self.collectionView.performBatchUpdates({ _ in
                    self.collectionView.insertItemsAtIndexPaths(indexPaths)
                
                    }, completion: { completed in
                    
                        if (completed) {
                            self.loadingNewPage = false
                        }
                })

            
            }, failureBlock: { _ in self.loadingNewPage = false })
    }


    // MARK - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemsCollection.sharedInstance.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let instagramMedia = ItemsCollection.sharedInstance.itemAtIndex(indexPath.row)
        
        cell.imageView.alpha = 0
        
        let url = urlResForMedia(instagramMedia)        
        let urlRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy , timeoutInterval: 10)
        
        cell.imageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { _, _, image in
        
            cell.imageView.image = image
            UIView.animateWithDuration(0.3) { _ in
                
                cell.imageView.alpha = 1
                if (instagramMedia.isVideo) {
                    cell.videoOverlay.hidden = false
                }
            }
            
            }, failure: { _, _, error in
                print("An error occurred retrieving the image:\(error).")
        })
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.alpha = 0.5
        
            let instagramMedia = ItemsCollection.sharedInstance.itemAtIndex(indexPath.row)
            let segueId = instagramMedia.isVideo ? "ShowVideo" : "ShowImage"
            performSegueWithIdentifier(segueId, sender: instagramMedia)
        }
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!shouldLoadNewPage() || loadingNewPage) {
            return
        } else {
            loadNewPage()
        }
    }
    
    
    // MARK - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let instagramMedia: InstagramMedia = sender as? InstagramMedia {
            
            if (segue.identifier == "ShowImage") {
                
                let detailsViewController = segue.destinationViewController as! ImageItemViewController
                detailsViewController.imageURL = instagramMedia.standardResolutionImageURL
            }
            
            if (segue.identifier == "ShowVideo") {
                
                let detailsViewController = segue.destinationViewController as! VideoItemViewController
                detailsViewController.videoURL = instagramMedia.standardResolutionVideoURL
            }
        }
    }
    
}




