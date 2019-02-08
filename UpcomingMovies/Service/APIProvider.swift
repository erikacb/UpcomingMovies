//
//  APIProvider.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Foundation
import Moya

class APIProvider {
    
    static let provider = MoyaProvider<APIService>()
    
    static func getUpcomingMovies(page: Int, completion: @escaping (UpcomingMovies) ->()) {
        provider.request(.upcomingMovies(page: page)) { (result) in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(UpcomingMovies.self, from: response.data)
                    completion(results)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    static func getMovieDetailsWithCredits(id: Int, completion: @escaping (Movie) -> ()) {
        provider.request(.movieDetailsWithCredits(id: id)) { (result) in
            print(result)
            
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(Movie.self, from: response.data)
                    completion(results)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    static func getGenreList(completion: @escaping (GenreList)-> ()) {
        provider.request(.genreList()) { (result) in
            
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(GenreList.self, from: response.data)
                    completion(results)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
            
        }
    }
    
}
