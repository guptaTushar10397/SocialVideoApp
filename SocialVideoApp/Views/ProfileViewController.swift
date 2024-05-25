//
//  ProfileViewController.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 24/05/24.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func profileViewControllerDidPressBackButton(_ controller: UIViewController)
}

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var profile: ProfileData!
    var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = profile.username ?? ""
        
        navigationItem.backAction = UIAction { _ in
            self.delegate?.profileViewControllerDidPressBackButton(self)
        }
        
        configureUI()
        setupCollectionView()
    }
}

private extension ProfileViewController {
    
    func configureUI() {
        let profileImage = UIImage(named: "placeholder_image")
        
        guard let profilePictureUrlString = profile.profilePictureUrl,
              let profilePictureUrl = URL(string: profilePictureUrlString) else {
            profileImageView.image = UIImage(named: "placeholder_profile")
            return
        }
        
        profileImageView.setImage(withURL: profilePictureUrl, placeholder: profileImage)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: (collectionView.bounds.width - 42) / 2, height: 150)
        collectionView.collectionViewLayout = collectionViewLayout
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profile.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", 
                                                            for: indexPath) as? PostCollectionCell,
              let post: Post = profile.posts?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configure(with: post)
        return cell
    }
}
