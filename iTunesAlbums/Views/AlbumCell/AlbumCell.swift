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
        
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: cellWidth)
        // also i've changed priority to top and bottom constraints in AlbumCell.xib
        widthConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            widthConstraint
        ])
    }

}
