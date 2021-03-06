//
//  AlbumDetailViewController.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

/**
 * Detail information of selected album with displaying of album songs.
 * With ability of playing the song. Currently playing song is displayed at the bottom in MusicPlayer
 */

import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    private let musicPlayerViewHeight: CGFloat = 60
    var musicPlayerView: MusicPlayerView!
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
            } else {
                Utils.showAlert(title: "Oops!", message: "Nothing found.", firstButtonText: "☹️")
            }
        }
    }
    
    private func setupView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: musicPlayerViewHeight, right: 0)
        albumLabel.text = album.albumName
        artistLabel.text = album.artistName
        
        // setting up imageView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(systemName: "arrow.down.square.fill")
        
        let width = view.bounds.width * 0.6
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: width),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let largeUrl = URL(string: album.largeImageUrl) {
            imageView.loadImage(url: largeUrl) { [weak self] in
                self?.headerView.setNeedsLayout()
            }
        }
        
        // setting up musicPlayerView
        musicPlayerView = MusicPlayerView.instanceFromNib()
        view.addSubview(musicPlayerView)
        musicPlayerView.configure()
        NSLayoutConstraint.activate([
            musicPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            musicPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            musicPlayerView.heightAnchor.constraint(equalToConstant: musicPlayerViewHeight)
        ])
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("Unable to dequeue 'Cell'")
        }
        
        cell.textLabel?.text = tracks[indexPath.row].trackName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicPlayerView.playTrack(track: tracks[indexPath.row], artworkUrl: album.smallImageUrl)
    }
}
