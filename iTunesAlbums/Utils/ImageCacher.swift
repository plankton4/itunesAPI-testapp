//
//  ImageCacher.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 01.12.2021.
//

import Foundation

class ImageCacher {
    
    static let shared = ImageCacher()
    
    private let cache = NSCache<NSURL, NSData>()
    
    private init() {}
    
    func getCachedImage(imageUrl: URL) -> Data? {
        return cache.object(forKey: imageUrl as NSURL) as Data?
    }
    
    func cacheImage(imageData: Data, imageUrl: URL) {
        cache.setObject(imageData as NSData, forKey: imageUrl as NSURL)
    }
}
