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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        let url = URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/22/d2/17/22d217f9-c5f9-2c6d-ae38-9a22af073d04/mzaf_9055110886505793905.plus.aac.p.m4a")
//        let playerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
//        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let width = view.bounds.width * 0.6
        imageViewHeightConstraint.constant = width
        imageViewWidthConstraint.constant = width
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.layoutIfNeeded()
        tableView.reloadData()
    }
    

}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "Text label"
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
}
