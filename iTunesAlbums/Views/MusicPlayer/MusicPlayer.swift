//
//  MusicPlayer.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 19.11.2021.
//

import UIKit
import AVFoundation

class MusicPlayer: UIView {
    
    enum PlayButtonState {
        case play, pause
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var songNameLabel: UILabel!
    var track: Track?
    var player: AVPlayer?
    
    
    class func instanceFromNib() -> MusicPlayer {
        return UINib(nibName: "MusicPlayer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MusicPlayer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        playButton.setTitle("", for: .normal)
        playButton.isEnabled = false
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        if player?.rate == 0 {
            player?.play()
            playButtonChangeState(state: .pause)
        } else {
            player?.pause()
            playButtonChangeState(state: .play)
        }
    }
    
    func playTrack(track: Track, artworkUrl: String) {
        if let smallUrl = URL(string: artworkUrl) {
            imageView.loadImage(url: smallUrl)
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
    
    func playButtonChangeState(state: PlayButtonState) {
        switch state {
        case .play:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .pause:
            playButton.isEnabled = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func finishedPlaying( _ notification: NSNotification) {
        print("Finished playing!")
        let targetTime: CMTime = CMTimeMake(value: 0, timescale: 1)
        player?.seek(to: targetTime)
        playButtonChangeState(state: .play)
    }
}
