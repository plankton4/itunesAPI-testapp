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
    private let interitemSpacing: CGFloat = 16
    var albumsView: UICollectionView!
    var albums: [Album] = []
    var searchString: String? // when not nil, we should search right away
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let searchString = searchString {
            performSearch(text: searchString, writeToHistory: false)
        }
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = interitemSpacing
        
        albumsView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        albumsView.translatesAutoresizingMaskIntoConstraints = false
        albumsView.showsVerticalScrollIndicator = false
        albumsView.backgroundColor = .systemBackground
        albumsView.delegate = self
        albumsView.dataSource = self
        albumsView.contentInset = UIEdgeInsets(
            top: 8,
            left: sideInsetDistance,
            bottom: 20,
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
    
    func performSearch(text: String, writeToHistory: Bool = true) {
        if writeToHistory {
            SearchHistory.shared.updateHistory(text: text)
        }
        
        albums.removeAll()
        albumsView.reloadData()
        
        Searcher.shared.searchAlbums(searchText: text) { [weak self] success in
            print("Success? \(success), albums count \(MusicData.shared.albums.count)")
            if success && !MusicData.shared.albums.isEmpty {
                self?.albums = MusicData.shared.albums
                self?.albumsView.reloadData()
            } else {
                Utils.showAlert(title: "Oops!", message: "Nothing found.", firstButtonText: "☹️")
            }
        }
    }
    
}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? AlbumCell else {
            fatalError("Unable to dequeue AlbumCell")
        }
        
        let width = CGFloat((view.bounds.width - interitemSpacing - sideInsetDistance * 2) / 2)
        cell.configure(
            cellWidth: width.rounded(.down),
            album: albums[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumDetailIdentifier") as? AlbumDetailViewController
        {
            vc.album = albums[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
