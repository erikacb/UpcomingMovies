//
//  Credits.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

struct Credits: Decodable {
    
    let cast: [Cast]?
    let crew: [Crew]?
    
    enum CodingKeys: String, CodingKey {
        case cast = "cast"
        case crew = "crew"
    }
    
}
