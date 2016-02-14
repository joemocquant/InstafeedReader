//
//  ImageItemViewController.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 11/17/15.
//  Copyright © 2015 InstafeedReader. All rights reserved.
//

import UIKit

class ImageItemViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: NSURL!
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.alpha = 0;
        let urlRequest = NSURLRequest(URL: imageURL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy , timeoutInterval: 10)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.imageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { _, _, image in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.imageView.image = image
            UIView.animateWithDuration(0.3) { _ in
                self.imageView.alpha = 1
            }
            
            }, failure: { _, _, error in
                
                print("An error occurred retrieving the image:\(error).")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
