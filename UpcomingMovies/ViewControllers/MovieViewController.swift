//
//  MovieViewController.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 07/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    var movie: Movie?
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillInfoChart(movie!)
        self.setViewHeightConstraint()
    }
    
    func fillInfoChart(_ movie: Movie) {
        self.title = self.movie?.title
        self.posterImageView.image = nil
        self.posterImageView.load(.poster, from: movie.posterPath!)
        self.overviewLabel.text = movie.overview ?? "No overview available"
        self.releaseDateLabel.text = DateFormatterHelper.convertDate(movie.releaseDate ?? "No release date available")
    }
    
    // MARK: - UIView Helpers
    
    func setViewHeightConstraint() {
        let height = self.posterImageView.frame.height + self.overviewLabel.frame.height + 160
        self.viewHeightConstraint.constant = height
    }
    
}
