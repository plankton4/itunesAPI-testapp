//
//  AlbumDetailViewController.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

import UIKit
import AVFoundation

class AlbumDetailViewController: UIViewController {
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    var player: AVPlayer?
    var album: Album!
    var tracks: [Track] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        Searcher.shared.searchSongs(albumId: album.albumId) { [weak self] success in
            if success {
                if let self = self, let tracks = MusicData.shared.tracks[self.album.albumId] {
                    self.tracks = tracks
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.bounds.width * 0.6
        imageViewHeightConstraint.constant = width
        imageViewWidthConstraint.constant = width
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func setupView() {
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        albumLabel.text = album.albumName
        artistLabel.text = album.artistName
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.down.square.fill")
        if let largeUrl = URL(string: album.largeImageUrl) {
            imageView.loadImage(url: largeUrl)
        }
    }
    

}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = tracks[indexPath.row].trackName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: tracks[indexPath.row].previewUrl)
        let playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}
