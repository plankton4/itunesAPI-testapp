//
//  UIImageView+DownloadImage.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 19.11.2021.
//

import UIKit

extension UIImageView {
    
    @discardableResult func loadImage(url: URL, callback: (() -> Void)? = nil) -> URLSessionDownloadTask? {
        let originalUrl = url

        if let cachedImageData = ImageCacher.shared.getCachedImage(imageUrl: originalUrl) {
            setImageFromData(imageData: cachedImageData)
            return nil
        } else {
            let session = Utils.imageDownloadSession
            let downloadTask = session.downloadTask(with: url) { [weak self] url, _, error in
                if error == nil,
                   let url = url,
                   let data = try? Data(contentsOf: url) {
                    ImageCacher.shared.cacheImage(imageData: data, imageUrl: originalUrl)
                    DispatchQueue.main.async {
                        if let weakSelf = self {
                            weakSelf.setImageFromData(imageData: data)
                            if let callback = callback {
                                callback()
                            }
                        }
                    }
                }
            }
            
            downloadTask.resume()
            return downloadTask
        }
    }
    
    private func setImageFromData(imageData: Data) {
        if let image = UIImage(data: imageData) {
            self.image = image
        }
    }
}
