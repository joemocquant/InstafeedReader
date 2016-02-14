//
//  FeedViewController+Layout.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 11/18/15.
//  Copyright © 2015 InstafeedReader. All rights reserved.
//

/*
*
* Layout logic:
*
* Number of columns and image resolution in collectionView is function of screen width resolution
*
* InstagramKit size:
*
* Thumbnail (Th): 150x150px
* LowResolution (Low): 320x320px
* StandardResolution (Std): 640x640px
*
* (http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)
*
* resolution width (pixels)  |   320  |   640  |   750   |  1125  |   1242
* Number of columns          |     2  |     2  |     3   |     4  |      4
* image type                 |    Th  |   Low  |   Low   |   Low  |    Low
*
*/

import Foundation
import InstagramKit

extension FeedViewController {
    
    static var widthRes: CGFloat {

        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenScale = UIScreen.mainScreen().scale

        return screenWidth * screenScale
    }
        
    static var heightRes: CGFloat {
            
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenScale = UIScreen.mainScreen().scale
        
        return screenHeight * screenScale
    }
    
    static var numColumns: Int {
        
        var numColumns = 2  //widthRes: 320px - 640px
        if (widthRes == 750) {
            numColumns = 3  //widthRes: 750px
        } else if (widthRes >= 1125) {
            numColumns = 4  //widthRes: 1125px - 1242px
        }

        return numColumns
    }
    
    static var cellSize: CGSize {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let margin = CGFloat(3.0)
        let size = (screenWidth - (CGFloat(numColumns) - 1) * margin) / CGFloat(numColumns)

        return CGSizeMake(size, size)
    }
    
    static var cellsPerPageCount: Int {
        
        let cellsPerScreenCount = Int(round(UIScreen.mainScreen().bounds.height / cellSize.height)) * numColumns
        let res = cellsPerScreenCount * 2

        return res
    }
    
    func urlResForMedia(media: InstagramMedia) -> NSURL {
        
        if (widthRes <= media.thumbnailFrameSize.width) {
            return media.thumbnailURL
        } else {
            return media.lowResolutionImageURL
        }
    }
}