//
//  MockService.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

class MockService {
    static let shared = MockService()

    private init() {}

    func fetchFeed(completion: @escaping (Feed?) -> Void) {
        if let url = Bundle.main.url(forResource: "feed", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let feed = try JSONDecoder().decode(Feed.self, from: data)
                completion(feed)
            } catch {
                print("Failed to load feed: \(error)")
                completion(nil)
            }
        }
    }

    func fetchPost(postId: String, completion: @escaping (Post?) -> Void) {
        if let url = Bundle.main.url(forResource: "posts", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let feed = try JSONDecoder().decode(Feed.self, from: data)
                let post = feed.data?.first { $0.postId == postId }
                completion(post)
            } catch {
                print("Failed to load post: \(error)")
                completion(nil)
            }
        }
    }

    func fetchProfile(username: String, completion: @escaping (ProfileData?) -> Void) {
        if let url = Bundle.main.url(forResource: "profile", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let profiles = try JSONDecoder().decode(Profile.self, from: data)
                if let profile = profiles.data?.first(where: { $0.username == username }) {
                    completion(profile)
                } else {
                    print("Profile not found for username: \(username)")
                    completion(nil)
                }
            } catch {
                print("Failed to load profile: \(error)")
                completion(nil)
            }
        }
    }
}


