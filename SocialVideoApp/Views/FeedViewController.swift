//
//  ViewController.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import UIKit
import AVFoundation

class FeedViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var feedViewModel = FeedViewModel()
    private var currentlyPlayingVideoIndexPath: IndexPath?
    private var cellHeight: CGFloat {
        tableView.frame.height - 80
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        
        setupTableView()
        fetchFeed()
    }
}

private extension FeedViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        tableView.separatorStyle = .none
        
    }
    
    func fetchFeed() {
        feedViewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                self.startPlayVideoForVisibleCell()
            }
        }
        
        feedViewModel.fetchFeed()
    }
    
    @objc private func refreshFeed() {
        fetchFeed()
    }
    
    func startPlayVideoForVisibleCell() {
        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else { return }
        
        if let currentlyPlayingVideoIndexPath = currentlyPlayingVideoIndexPath {
            guard let cell = tableView.cellForRow(at: currentlyPlayingVideoIndexPath) as? PostCell else { return }
            cell.pauseVideo()
        }
        
        for indexPath in indexPathsForVisibleRows {
            guard let cell = tableView.cellForRow(at: indexPath) as? PostCell else { continue }
            let cellRect = tableView.rectForRow(at: indexPath)
            let completelyVisible = tableView.bounds.contains(cellRect)
            
            if completelyVisible {
                cell.playVideo()
                currentlyPlayingVideoIndexPath = indexPath
            } else {
                cell.pauseVideo()
            }
        }
    }
    
    func showPostViewController(with post: Post, currentTime: CMTime) {
        guard let postId = post.postId,
        let username = post.username else { return }
        
        guard let postViewController = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {
            return
        }
        
        postViewController.postId = postId
        postViewController.username = username
        postViewController.startPlaybackTime = currentTime
        postViewController.delegate = self
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        let post = feedViewModel.posts[indexPath.row]
        cell.configure(with: post)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostCell,
        let currentTime = cell.currentPlaybackTime() else { return }
        cell.pauseVideo()
        let post = feedViewModel.posts[indexPath.row]
        showPostViewController(with: post, currentTime: currentTime)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startPlayVideoForVisibleCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startPlayVideoForVisibleCell()
        }
    }
}

extension FeedViewController: PostViewControllerDelegate {
    func postViewControllerDidPressBackButton(_ controller: UIViewController, currentTime: CMTime?) {
        navigationController?.popViewController(animated: true)
        guard let currentlyPlayingVideoIndexPath = currentlyPlayingVideoIndexPath,
              let cell = tableView.cellForRow(at: currentlyPlayingVideoIndexPath) as? PostCell else { return }
        if let currentTime = currentTime {
            cell.seek(to: currentTime)
        }
        cell.playVideo()
    }
    
    func postViewControllerDidPressBackButton(_ controller: UIViewController) {
        navigationController?.popViewController(animated: true)
        
    }
}
