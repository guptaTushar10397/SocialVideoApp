//
//  PostCell.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import UIKit
import AVFoundation


class PostCell: UITableViewCell {
    @IBOutlet private weak var videoPlayerView: VideoPlayerView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayerView.configure(with: "")
        usernameLabel.text = nil
        likesLabel.text = nil
    }

    func configure(with post: Post) {
        usernameLabel.text = "@\(post.username ?? "")"
        likesLabel.text = "Likes: \(post.likes ?? 0)"
        videoPlayerView.configure(with: post.videoUrl ?? "")
    }
        
    @objc func playVideo() {
        videoPlayerView.play()
    }
    
    func pauseVideo() {
        videoPlayerView.pause()
    }
    
    func currentPlaybackTime() -> CMTime? {
        return videoPlayerView.currentTime()
    }
    
    func seek(to time: CMTime) {
        videoPlayerView?.seek(to: time)
    }
}

