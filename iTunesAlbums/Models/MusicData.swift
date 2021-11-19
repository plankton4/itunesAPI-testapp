//
//  MusicData.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import Foundation

class MusicData {
    
    static let shared = MusicData()
    var albums: [Album] = []
    var tracks: [Int: [Track]] = [:]
    
    private init() {}
    
    func fillData(data: [Searcher.SearchResult], type: DataType) {
        switch type {
        case .album:
            albums.removeAll()
            for result in data {
                let album = Album(
                    artistName: result.artistName ?? "Unknown",
                    albumName: result.albumName ?? "Unknown",
                    smallImageUrl: result.artworkSmall ?? "",
                    collectionId: result.collectionId ?? -1)
                albums.append(album)
            }
        case .song:
            break
        case .unknown:
            break
        }
    }
}

extension MusicData {
    
    enum DataType {
        case album, song
        case unknown
    }
    
    enum ImageSize {
        case small, medium, large
    }
}
