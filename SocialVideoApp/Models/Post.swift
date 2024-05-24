//
//  Post.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

struct Post: Codable {
    let postId: String?
    let videoUrl: String?
    let thumbnail_url: String?
    let username: String?
    let likes: Int?
}
