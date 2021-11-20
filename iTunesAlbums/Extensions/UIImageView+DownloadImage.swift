//
//  UIImageView+DownloadImage.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 19.11.2021.
//

import UIKit

extension UIImageView {
    
    @discardableResult func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = Utils.imageDownloadSession 
        let downloadTask = session.downloadTask(with: url) { [weak self] url, _, error in
            if error == nil,
               let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        
        downloadTask.resume()
        return downloadTask
    }
}
