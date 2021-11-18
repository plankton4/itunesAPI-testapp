//
//  AlbumCell.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(cellWidth: CGFloat) {
        imageView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: cellWidth)
        ])
    }

}
