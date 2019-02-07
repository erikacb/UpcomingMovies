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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with movie: Movie) {
        self.posterImageView.load(.poster, from: movie.posterPath!)
        self.movieTitleLabel.text = movie.title ?? "No title available"
        self.releaseDateLabel.text = self.convertDate(movie.releaseDate ?? "")
    }
    
    private func convertDate(_ date: String) -> String {
        if date != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return "Release date: " + dateFormatter.string(from: date!)
        } else {
            return "No release date available"
        }

    }
    
}
