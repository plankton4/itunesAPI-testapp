//
//  AlbumsCollectionVC.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 17.11.2021.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let reuseIdentifier = "AlbumCell"
    private let sideInsetDistance: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        let albumsView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        albumsView.translatesAutoresizingMaskIntoConstraints = false
        albumsView.showsVerticalScrollIndicator = false
        albumsView.backgroundColor = .systemBackground
        albumsView.delegate = self
        albumsView.dataSource = self
        albumsView.contentInset = UIEdgeInsets(
            top: 8,
            left: sideInsetDistance,
            bottom: 8,
            right: sideInsetDistance)
        
        let nibName = UINib(nibName: "AlbumCell", bundle: nil)
        albumsView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(albumsView)
        
        NSLayoutConstraint.activate([
            albumsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumsView.topAnchor.constraint(equalTo: view.topAnchor),
            albumsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? AlbumCell else {
            fatalError("Unable to dequeue AlbumCell")
        }
        
        let w = CGFloat((view.bounds.width - sideInsetDistance * 2) / 2)
        cell.configure(cellWidth: w.rounded(.down))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumDetailIdentifier") as? AlbumDetailViewController
        {
            //vc.initialIndex = indexPath.item
            //vc.photos = UserData.shared.photos
            navigationController?.pushViewController(vc, animated: true)
        }
        //performSegue(withIdentifier: "AlbumDetailSegue", sender: self)
    }
}
