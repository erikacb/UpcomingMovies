//
//  HomeViewController.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Testing... \o/
        
        APIProvider.getUpcomingMovies(page: 1) { (results) in
            print("UPCOMING MOVIES (FIRST)")
            print("Title: \(results.results?.first?.title ?? "No title")")
            print("Id: \(results.results?.first?.id ?? 0)")
            print("Gender Ids: \(results.results?.first?.genreIds ?? [])")
        }
        
        APIProvider.getMovieDetailsWithCredits(id: 522681) { (results) in
            print("SINGLE MOVIE")
            print("Title: \(results.title ?? "No title")")
            print("Id: \(results.id ?? 0)")
            print("Gender Ids: \(results.genres ?? [])")
        }
        
    }
    
}
