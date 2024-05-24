//
//  UIImageView+Extension.swift
//  SocialVideoApp
//
//  Created by Tushar Gupta on 24/05/24.
//

import UIKit

extension UIImageView {
    
    func setImage(withURL url: URL, placeholder: UIImage? = nil) {
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }
        
        self.image = placeholder
        
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            
            ImageCache.shared.save(image, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
