//
//  APIService.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import Moya

enum APIService {
    case upcomingMovies(page: Int)
    case movieDetailsWithCredits(id: Int)
    case genreList()
}

extension APIService: TargetType {
    
    static let key = "1f54bd990f1cdfb230adb312546d765d"
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .upcomingMovies( _):
            return "movie/upcoming"
        case .movieDetailsWithCredits(let id):
            return "movie/\(id)"
        case .genreList():
            return "genre/movie/list"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .upcomingMovies(let page):
            return .requestParameters(parameters: ["api_key": APIService.key, "page": page],
                                      encoding: URLEncoding.queryString)
        case .movieDetailsWithCredits(let id):
            return .requestParameters(parameters: ["api_key": APIService.key, "id": id, "append_to_response": "credits"],
                                      encoding: URLEncoding.queryString)
        case .genreList():
            return .requestParameters(parameters: ["api_key": APIService.key],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
