//
//  Album.swift
//  swift-playground
//
//  Created by skyline on 15/6/24.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

class Album {
    var name: String
    var artist: String
    init(name: String, artist: String) {
        self.name = name;
        self.artist = artist;
    }
}

extension Album: CustomDebugStringConvertible {
    internal var debugDescription: String {
        return "[\(artist): \(name)]"
    }
}

extension Album: CustomStringConvertible {
    var description: String {
        return "\(artist) - \(name)"
    }
}
