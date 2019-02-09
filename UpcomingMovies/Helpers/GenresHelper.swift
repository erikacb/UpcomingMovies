//
//  GenresHelper.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 09/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation

class GenresHelper {
    
    class func findGenres(for genreIds: [Int], using genreList: GenreList) -> String {
        
        if genreIds.count > 0 && (genreList.genres?.count)! > 0 {
            
            let genreStringArray = genreList.genres?.filter { (genre) -> Bool in
                genreIds.contains(genre.id!)
                }.map({ (genre) -> String in
                    genre.name ?? "No genre name"
                })
            
            var genres: String = ""
            
            if (genreStringArray?.count)! > 0 {
                genreStringArray?.forEach({ (genre) in
                    genres.append(genre + "   ")
                })
            }
            
            return genres
        } else {
            return "Unable to retrieve genres"
        }
        
    }
    
}
