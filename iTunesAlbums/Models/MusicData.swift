//
//  MusicData.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import Foundation

class MusicData {
    
    static let shared = MusicData()
    private let concurrentMusicDataQueue = DispatchQueue(label: "MusicDataQueue", attributes: .concurrent)
    private var unsafeAlbums: [Album] = []
    var albums: [Album] {
        var albumsCopy: [Album] = []

        concurrentMusicDataQueue.sync {
            albumsCopy = self.unsafeAlbums
        }
        return albumsCopy
    }
    private var unsafeTracks: [Int: [Track]] = [:] // key - Album.albumId
    var tracks: [Int: [Track]] {
        var tracksCopy: [Int: [Track]] = [:]
        
        concurrentMusicDataQueue.sync {
            tracksCopy = self.unsafeTracks
        }
        return tracksCopy
    }
    
    
    private init() {}
    
    func fillData(data: [Searcher.SearchResult], type: DataType) {
        concurrentMusicDataQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            
            switch type {
            case .album:
                self.unsafeAlbums.removeAll()
                for result in data where result.type == .album {
                    let album = Album(
                        artistName: result.artistName ?? "Unknown",
                        albumName: result.albumName ?? "Unknown",
                        smallImageUrl: result.artworkSmall ?? "",
                        collectionId: result.collectionId ?? -1)
                    self.unsafeAlbums.append(album)
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
                    self.unsafeTracks[albumId] = localTracks
                }
            case .unknown:
                break
            }
        }
    }
    
    func clearAlbums() {
        concurrentMusicDataQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.unsafeAlbums.removeAll()
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
