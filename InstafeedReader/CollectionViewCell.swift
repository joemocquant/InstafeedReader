//
//  CollectionViewCell.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 11/17/15.
//  Copyright © 2015 InstafeedReader. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoOverlay: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        videoOverlay.hidden = true
    }
}
