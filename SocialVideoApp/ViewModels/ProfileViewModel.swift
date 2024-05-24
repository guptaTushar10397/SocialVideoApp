//
//  ProfileViewModel.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 23/05/24.
//

import Foundation

class ProfileViewModel {
    var profile: ProfileData?
    var reloadData: (() -> Void)?

    func fetchProfile(username: String) {
        MockService.shared.fetchProfile(username: username) { [weak self] profile in
            self?.profile = profile
            self?.reloadData?()
        }
    }
}

