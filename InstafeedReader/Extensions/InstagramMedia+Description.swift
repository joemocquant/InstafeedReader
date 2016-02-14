//
//  InstagramMedia+Description.swift
//  InstafeedReader
//
//  Created by Joe Mocquant on 7/6/15.
//  Copyright (c) 2015 InstafeedReader. All rights reserved.
//

import Foundation
import InstagramKit

extension InstagramMedia {
    
    var prettyDescription: String {
        return "\n URL: \(thumbnailURL) \n Created: \(createdDate) \n)"
    }
}