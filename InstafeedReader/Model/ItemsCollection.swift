//
//  ItemsCollection.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 11/18/15.
//  Copyright © 2015 InstafeedReader. All rights reserved.
//

import InstagramKit
import CoreData

class ItemsCollection {

    static let sharedInstance = ItemsCollection()
    var userId: String!
    var instagramUser: InstagramUser!
    var endReached = false
    
    private var items = [InstagramMedia]()
    private var currentPaginationInfo = InstagramPaginationInfo()
    
    
    var count: Int {
        return items.count
    }
    
    func addItems(newItems: Array<InstagramMedia>) {
        
        items.appendContentsOf(newItems)
    }
    
    func itemAtIndex(index: Int) -> InstagramMedia {
        return items[index]
    }
    
    func removeAll() {
        currentPaginationInfo = InstagramPaginationInfo()
        items.removeAll()
        endReached = false
    }
    
    func retrieveNewItems(count: Int, successBlock: (indexPaths: [NSIndexPath]) -> Void, failureBlock: () -> Void) {
        
        //TODO if no network -> loadResults

        InstagramEngine.sharedEngine().getMediaForUser(userId, count: count, maxId: currentPaginationInfo.nextMaxId, withSuccess: { (results: [InstagramMedia], info: InstagramPaginationInfo) -> Void in
        
            self.currentPaginationInfo = info
            if (info.nextMaxId == "") {
                self.endReached = true
            }
            
            var indexPaths = [NSIndexPath]()
                
            for index in 0..<results.count {
                let indexPath = NSIndexPath(forRow: ItemsCollection.sharedInstance.count + index, inSection: 0)
                indexPaths.append(indexPath)
            }
                
            self.addItems(results)
            successBlock(indexPaths: indexPaths)
                
            //self.saveResults(results)
            
            
        }) { (error: NSError, code: Int) -> Void in
            
            print("An error occurred retrieving Instagram Feed.")
            failureBlock()
        }
    }
    
    
    // MARK: - CoreData
    
    func saveResults(results: [InstagramMedia]) {

    }
    
    func loadResults() {
        
    }
}
