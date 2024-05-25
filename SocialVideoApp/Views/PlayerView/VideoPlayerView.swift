//
//  VideoPlayerView.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import UIKit
import AVFoundation

protocol VideoPlayerViewOutput: AnyObject {
    func videoPlayerViewItemDidPlayToEndTime(for playerItem: CustomAVPlayerItem)
}

class VideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    weak var delegate: VideoPlayerViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupPlayer() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.cornerRadius = 10
        playerLayer!.masksToBounds = true
        playerLayer!.frame = bounds
        playerLayer!.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    func configure(with videoUrl: String, uniqueId: String) {
        guard let url = URL(string: videoUrl) else { return }
        let avPlayerItem = CustomAVPlayerItem(url: url)
        avPlayerItem.uniqueId = uniqueId
        player?.pause()
        player = AVPlayer(playerItem: avPlayerItem)
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
    
    @objc private func restartVideo(notification: NSNotification) {
        guard let playerItem = notification.object as? CustomAVPlayerItem else { return }
        delegate?.videoPlayerViewItemDidPlayToEndTime(for: playerItem)
    }
}
