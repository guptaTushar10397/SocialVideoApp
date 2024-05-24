//
//  PostViewModel.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

class PostViewModel {
    var post: Post?
    var reloadData: (() -> Void)?

    func fetchPost(postId: String) {
        MockService.shared.fetchPost(postId: postId) { [weak self] post in
            self?.post = post
            self?.reloadData?()
        }
    }
}

