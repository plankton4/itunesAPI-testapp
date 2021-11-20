//
//  Searcher.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import Foundation

class Searcher {
    
    static let shared = Searcher()
    private var dataTask: URLSessionDataTask?
    lazy private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    private func getUrl(searchTerm: String, type: MusicData.DataType) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        
        switch type {
        case .album:
            components.path = "/search"
            components.queryItems = [
                URLQueryItem(name: "media", value: "music"),
                URLQueryItem(name: "entity", value: "album"),
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "term", value: "\(searchTerm)")
            ]
        case .song:
            components.path = "/lookup"
            components.queryItems = [
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "id", value: "\(searchTerm)"),
            ]
        default:
            return nil
        }
        
        return components.url
    }
    
    func searchAlbums(searchText: String, completion: @escaping (Bool) -> Void) {
        if let url = getUrl(searchTerm: searchText, type: .album) {
            search(url: url, type: .album, completion: completion)
        }
    }
    
    func searchSongs(albumId: Int, completion: @escaping (Bool) -> Void) {
        print("Search songs")
        if let url = getUrl(searchTerm: String(albumId), type: .song) {
            search(url: url, type: .song, completion: completion)
        }
    }
    
    func cancelSearch() {
        dataTask?.cancel()
    }
    
    private func search(url: URL, type: MusicData.DataType, completion: @escaping (Bool) -> Void) {
        print("Search url \(url)")
        dataTask?.cancel()
        dataTask = session.dataTask(with: url) { data, response, error in
            var success = false
            print("Data task end, error \(String(describing: error)), response \(String(describing: response))")
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200, let data = data {
                let searchResults = self.parse(data: data)
                //print("SearchResults count \(searchResults.count)")
                //print("SearchResults \(searchResults)")
                MusicData.shared.fillData(data: searchResults, type: type)
                success = true
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
        dataTask?.resume()
    }
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Results.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}

// MARK: - additional enums, structs...
extension Searcher {
    
    private struct Results: Codable {
        var resultCount = 0
        var results: [SearchResult] = []
    }
    
    struct SearchResult: Codable {
        var wrapperType: String? = ""
        
        // Album properties
        var artistName: String? = ""
        var albumName: String? = ""
        var artworkSmall: String? = ""
        var collectionId: Int? = 0
        var collectionType: String? = ""
        
        // Track properties
        var trackName: String? = ""
        var previewUrl: String? = ""
        
        enum CodingKeys: String, CodingKey {
            case wrapperType
            case artistName
            case albumName = "collectionName"
            case artworkSmall = "artworkUrl100"
            case collectionId, collectionType
            case trackName
            case previewUrl
        }
        
        var type: MusicData.DataType {
            if let wrapperType = wrapperType {
                if wrapperType == "track" {
                    return .song
                } else if wrapperType == "collection" {
                    if let collectionType = collectionType, collectionType == "Album" {
                        return .album
                    }
                }
            }
            return .unknown
        }
    }
}

