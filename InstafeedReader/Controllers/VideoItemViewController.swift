//
//  VideoItemViewController.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 12/19/15.
//  Copyright © 2015 InstafeedReader. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoItemViewController: AVPlayerViewController {
    
    var videoURL: NSURL!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBarHidden = true
        player = AVPlayer(URL: videoURL!)
        
        //http://stackoverflow.com/questions/32860362/unable-to-simultaneously-satisfy-constraints-warnings-with-avplayerviewcontrolle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
