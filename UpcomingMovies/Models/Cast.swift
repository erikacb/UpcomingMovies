//
//  Cast.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

struct Cast: Decodable {
    
    let castId: Int?
    let character: String?
    let creditId: String?
    let gender: Int?
    let name: String?
    let order: Int?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case character = "character"
        case creditId = "credit_id"
        case gender = "gender"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }
    
}
