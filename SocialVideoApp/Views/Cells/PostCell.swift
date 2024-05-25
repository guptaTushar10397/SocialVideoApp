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
    @IBOutlet private weak var repeatButton: UIButton!
    
    var post: Post? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupCell()
    }

    @IBAction func viewDidTapOnRepeatButton(_ sender: Any) {
        repeatButton.isHidden = true
        videoPlayerView.seek(to: .zero)
        videoPlayerView.play()
    }
    
    func configure(with post: Post) {
        self.post = post
        
        usernameLabel.text = "@\(post.username ?? "")"
        repeatButton.isHidden = true
        likesLabel.text = "Likes: \(post.likes ?? 0)"
        
        guard let postId = post.postId else {
            fatalError("PostId can not be nil")
        }
        
        videoPlayerView.configure(with: post.videoUrl ?? "", uniqueId: postId)
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
    
    func hideRepeatButton() {
        repeatButton.isHidden = true
    }
}

private extension PostCell {
    
    func setupCell() {
        usernameLabel.text = nil
        likesLabel.text = nil
        videoPlayerView.delegate = self
    }
}

extension PostCell: VideoPlayerViewOutput {
    
    func videoPlayerViewItemDidPlayToEndTime(for playerItem: CustomAVPlayerItem) {
        guard let post = self.post,
        let postID = post.postId,
        postID == playerItem.uniqueId else { return }
        repeatButton.isHidden = false
    }
}
