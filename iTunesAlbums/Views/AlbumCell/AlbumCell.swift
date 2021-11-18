//
//  AlbumCell.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var artistName: UILabel!
    var downloadTask: URLSessionDownloadTask?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        imageView.image = nil
    }
    
    func configure(cellWidth: CGFloat, album: Album) {
        imageView.layer.cornerRadius = 10
        albumName.text = album.albumName
        artistName.text = album.artistName
        
        imageView.image = UIImage(systemName: "arrow.down.square.fill")
        if let mediumUrl = URL(string: album.mediumImageUrl) {
            downloadTask = imageView.loadImage(url: mediumUrl)
        }
        
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: cellWidth)
        // also i've changed priority to top and bottom constraints in AlbumCell.xib
        widthConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            widthConstraint
        ])
    }

}
