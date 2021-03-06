//
//  Album.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import Foundation

class Album {
    
    var artistName: String
    var albumName: String
    var smallImageUrl: String
    var albumId: Int
    
    lazy var mediumImageUrl: String = {
        return smallImageUrl.replacingOccurrences(of: "100x100", with: "450x450")
    }()
    
    lazy var largeImageUrl: String = {
        return smallImageUrl.replacingOccurrences(of: "100x100", with: "700x700")
    }()
    
    init(artistName: String, albumName: String, smallImageUrl: String, collectionId: Int) {
        self.artistName = artistName
        self.albumName = albumName
        self.smallImageUrl = smallImageUrl
        self.albumId = collectionId
    }
}
