//
//  Profile.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

struct Profile: Codable {
    let status: String?
    let data: [ProfileData]?
}

struct ProfileData: Codable {
    let username: String?
    let profilePictureUrl: String?
    let posts: [Post]?
}

