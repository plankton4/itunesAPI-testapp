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
                    mediumImageUrl: getImageUrl(size: .medium, originalUrl: result.artworkSmall) ?? "",
                    largeImageUrl: getImageUrl(size: .large, originalUrl: result.artworkSmall) ?? "",
                    collectionId: result.collectionId ?? -1)
                albums.append(album)
            }
        case .song:
            break
        case .unknown:
            break
        }
    }
    
    func getImageUrl(size: ImageSize, originalUrl: String?) -> String? {
        guard let originalUrl = originalUrl else {
            return nil
        }
        
        switch size {
        case .small:
            return originalUrl
        case .medium:
            return originalUrl.replacingOccurrences(of: "100x100", with: "450x450")
        case .large:
            return originalUrl.replacingOccurrences(of: "100x100", with: "700x700")
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
