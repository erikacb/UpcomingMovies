//
//  GenreList.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 08/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

struct GenreList: Decodable {
    
    let genres: [Genre]?
    
    init(genres: [Genre]) {
        if genres.count > 0 {
            self.genres = genres
        } else {
            self.genres = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
    
}
