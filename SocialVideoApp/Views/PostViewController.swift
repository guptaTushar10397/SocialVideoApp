//
//  PostViewController.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 24/05/24.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewControllerDidPressBackButton(_ controller: UIViewController, currentTime: CMTime?)
    func postViewControllerDidPressRepeatButton(_ controller: UIViewController)
}

class PostViewController: UIViewController {

    @IBOutlet private weak var videoPlayerView: VideoPlayerView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var repeatButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    var postId: String!
    var username: String!
    var startPlaybackTime: CMTime!
    
    weak var delegate: PostViewControllerDelegate?
    
    private var postViewModel = PostViewModel()
    private var profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
        setupView()
        fetchData()
        
        navigationItem.backAction = UIAction { _ in
            self.delegate?.postViewControllerDidPressBackButton(self, currentTime: self.videoPlayerView.currentTime())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayerView.pause()
    }
    
    @IBAction func viewDidTapOnLikeButton(_ sender: Any) {
        toggleLikeButtonImage()
    }
    
    @IBAction func viewDidTapOnProfileButton(_ sender: Any) {
        guard let profile = profileViewModel.profile else { return }
        showProfileViewController(with: profile)
    }
    
    @IBAction func viewDidTapOnRepeatButton(_ sender: Any) {
        delegate?.postViewControllerDidPressRepeatButton(self)
        repeatButton.isHidden = true
        videoPlayerView.seek(to: .zero)
        videoPlayerView.play()
    }
}

private extension PostViewController {
    
    func setupView() {
        usernameLabel.text = nil
        profileImageView.image = nil
        repeatButton.isHidden = true
        videoPlayerView.delegate = self
        likesLabel.text = nil
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func fetchData() {
        guard let postId = postId, let username = username else { return }
        
        postViewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let post = postViewModel.post else { return }
                self.configureUI(with: post)
            }
        }
        
        profileViewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let user = profileViewModel.profile else { return }
                self.updateUserUI(with: user)
            }
        }
        
        postViewModel.fetchPost(postId: postId)
        profileViewModel.fetchProfile(username: username)
    }
    
    func configureUI(with post: Post) {
        usernameLabel.text = "@\(post.username ?? "")"
        videoPlayerView.configure(with: post.videoUrl ?? "", uniqueId: postId)
        videoPlayerView.play()
        videoPlayerView.seek(to: startPlaybackTime)
        likesLabel.text = "Likes: \(post.likes ?? 0)"
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func updateUserUI(with user: ProfileData) {
        let profileImage = UIImage(named: "placeholder_image")
        
        guard let profilePictureUrlString = user.profilePictureUrl,
              let profilePictureUrl = URL(string: profilePictureUrlString) else {
            profileImageView.image = UIImage(named: "placeholder_profile")
            return
        }
        
        profileImageView.setImage(withURL: profilePictureUrl, placeholder: profileImage)
    }
    
    private func toggleLikeButtonImage() {
        if let currentImage = likeButton.currentImage, currentImage == UIImage(systemName: "heart") {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likesLabel.text = "Likes: \((postViewModel.post?.likes ?? 0) + 1)"
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likesLabel.text = "Likes: \(postViewModel.post?.likes ?? 0)"
        }
    }
    
    func showProfileViewController(with profile: ProfileData) {
        guard let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            return
        }
        
        profileViewController.profile = profile
        profileViewController.delegate = self
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension PostViewController: ProfileViewControllerDelegate {
    
    func profileViewControllerDidPressBackButton(_ controller: UIViewController) {
        navigationController?.popViewController(animated: true)
        videoPlayerView.play()
    }
}

extension PostViewController: VideoPlayerViewOutput {
    
    func videoPlayerViewItemDidPlayToEndTime(for playerItem: CustomAVPlayerItem) {
        guard postId == playerItem.uniqueId else { return }
        repeatButton.isHidden = false
    }
}
