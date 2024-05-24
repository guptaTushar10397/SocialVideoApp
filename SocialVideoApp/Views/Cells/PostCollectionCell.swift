//
//  PostCollectionCell.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 24/05/24.
//

import UIKit

class PostCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func configure(with post: Post) {
        let placeholderImage = UIImage(named: "placeholder_image")
        thumbnailImageView.image = placeholderImage
        
        guard let thumbnailUrlString = post.thumbnail_url,
              let thumbnailUrl = URL(string: thumbnailUrlString) else {
            thumbnailImageView.image = placeholderImage
            return
        }
        
        thumbnailImageView.setImage(withURL: thumbnailUrl, placeholder: placeholderImage)
    }

}
