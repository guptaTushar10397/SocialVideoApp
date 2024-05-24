//
//  FeedViewModel.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

class FeedViewModel {
    var posts: [Post] = []
    var reloadData: (() -> Void)?

    func fetchFeed() {
        MockService.shared.fetchFeed { [weak self] feed in
            guard let self = self, let feed = feed else { return }
            self.posts = feed.data ?? []
            self.reloadData?()
        }
    }
}

