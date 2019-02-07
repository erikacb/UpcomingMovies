//
//  UIImageViewExtension.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit
import SDWebImage

enum ImageType {
    case backdrop
    case poster
}

extension UIImageView {
    
    func load(_ imageType: ImageType, from urlString: String) {
        var url = "https://image.tmdb.org/t/p/"
    
        switch imageType {
        case .backdrop: url += "w780" + urlString
        case .poster: url += "w300" + urlString
        }
        
        if urlString != "" {
            self.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
                self.setNeedsLayout()
            }
        } else {
            self.image = nil
            self.image = UIImage(named: "movie_placeholder")
        }
        
    }
    
}
