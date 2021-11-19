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
    var tracks: [Int: [Track]] = [:] // key - Album.albumId
    
    private init() {}
    
    func fillData(data: [Searcher.SearchResult], type: DataType) {
        switch type {
        case .album:
            albums.removeAll()
            for result in data where result.type == .album {
                let album = Album(
                    artistName: result.artistName ?? "Unknown",
                    albumName: result.albumName ?? "Unknown",
                    smallImageUrl: result.artworkSmall ?? "",
                    collectionId: result.collectionId ?? -1)
                albums.append(album)
            }
        case .song:
            var localTracks: [Track] = []
            for result in data where result.type == .song {
                let track = Track(
                    trackName: result.trackName ?? "",
                    previewUrl: result.previewUrl ?? "",
                    albumId: result.collectionId ?? -1)
                localTracks.append(track)
            }
            if let albumId = localTracks.first?.albumId {
                self.tracks[albumId] = localTracks
            }
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
