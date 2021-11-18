//
//  AlbumsCollectionVC.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 17.11.2021.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let cellSize = CGSize(width: 100, height: 100)
        layout.itemSize = cellSize
        let albumsView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        albumsView.translatesAutoresizingMaskIntoConstraints = false
        albumsView.showsVerticalScrollIndicator = false
        albumsView.backgroundColor = .systemBackground
        albumsView.delegate = self
        albumsView.dataSource = self
        albumsView.contentInset = UIEdgeInsets(
            top: 8, left: 8, bottom: 8, right: 8)
        //let nibName = UINib(nibName: "SquarePhotoCell", bundle: nil)
        //bottomPhotoView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
        //let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        albumsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DOGE")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DOGE", for: indexPath)
        //cell.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        cell.backgroundColor = .systemPurple
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
