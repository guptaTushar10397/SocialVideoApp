//
//  VideoPlayerView.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayer()
    }
    
    private func setupPlayer() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.cornerRadius = 10
        playerLayer!.masksToBounds = true
        playerLayer!.frame = bounds
        playerLayer!.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    func configure(with videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        player?.pause()
        player = AVPlayer(url: url)
        playerLayer?.player = player
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func currentTime() -> CMTime? {
        return player?.currentTime()
    }
    
    func seek(to time: CMTime) {
        player?.seek(to: time)
    }
}
