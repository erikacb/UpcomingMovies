//
//  HomeTableViewCell.swift
//  UpcomingMovies
//
//  Created by Erika Bueno on 06/02/19.
//  Copyright © 2019 8sys. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with movie: Movie, and genreList: GenreList) {
        self.posterImageView.load(.poster, from: movie.posterPath ?? "")
        self.genresLabel.text = GenresHelper.findGenres(for: movie.genreIds ?? [], using: genreList)
        self.movieTitleLabel.text = movie.title ?? "No title available"
        self.releaseDateLabel.text = DateFormatterHelper.convertDate(movie.releaseDate ?? "No release date available")
    }
    
}
