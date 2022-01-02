//
//  MusicPlayer.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 19.11.2021.
//

import UIKit
import AVFoundation

class MusicPlayerView: UIView {
    
    private enum PlayButtonState {
        case play, pause, defaultState
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var songNameLabel: UILabel!
    
    private let musicPlayerPlaceChangedNotification = Notification.Name(rawValue: "MusicPlayerPlaceChangedNotification")
    var track: Track?
    var player: AVPlayer?
    
    class func instanceFromNib() -> MusicPlayerView {
        return UINib(nibName: "MusicPlayer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MusicPlayerView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        listenForPlaceChanged()
    }
    
    @IBAction private func playButtonClicked(_ sender: UIButton) {
        if player?.rate == 0 {
            player?.play()
            playButtonChangeState(state: .pause)
        } else {
            player?.pause()
            playButtonChangeState(state: .play)
        }
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        playButton.setTitle("", for: .normal)
        playButton.isEnabled = false
    }
    
    func playTrack(track: Track, artworkUrl: String) {
        NotificationCenter.default.post(name: musicPlayerPlaceChangedNotification, object: nil, userInfo: ["musicPlayerObject": self])
        
        if let imageUrl = URL(string: artworkUrl) {
            imageView.loadImage(url: imageUrl)
        }
        songNameLabel.text = track.trackName
        
        if let url = URL(string: track.previewUrl) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
            player?.play()
            playButtonChangeState(state: .pause)
        }
    }
    
    private func playButtonChangeState(state: PlayButtonState) {
        switch state {
        case .play:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .pause:
            playButton.isEnabled = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .defaultState:
            playButton.isEnabled = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc private func finishedPlaying( _ notification: NSNotification) {
        let targetTime: CMTime = CMTimeMake(value: 0, timescale: 1)
        player?.seek(to: targetTime)
        playButtonChangeState(state: .play)
    }
    
    /**
     * this is needing when we try to play song from two different pages at once
     * so in another active MusicPlayer we need to reset state to default values
     */
    private func listenForPlaceChanged() {
        NotificationCenter.default.addObserver(
            forName: musicPlayerPlaceChangedNotification,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in
                if let weakSelf = self {
                    if let userInfo = notification.userInfo {
                        if let musicPlayerObject = userInfo["musicPlayerObject"] as? MusicPlayerView, musicPlayerObject !== weakSelf {
                            weakSelf.resetToDefaultState()
                        }
                    }
                }
            }
    }
    
    private func resetToDefaultState() {
        player = nil
        track = nil
        imageView.image = nil
        songNameLabel.text = "Not playing"
        playButtonChangeState(state: .defaultState)
    }
}
