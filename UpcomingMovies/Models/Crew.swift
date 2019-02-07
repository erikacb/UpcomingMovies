//
//  Crew.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

struct Crew: Decodable {
    
    let creditId: String?
    let department: String?
    let gender: Int?
    let id: Int?
    let job: String?
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case creditId = "credit_id"
        case department = "department"
        case gender = "gender"
        case id = "id"
        case job = "job"
        case name = "name"
        case profilePath = "profile_path"
    }
    
}
