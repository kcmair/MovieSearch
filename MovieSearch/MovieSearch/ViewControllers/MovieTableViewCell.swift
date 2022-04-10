//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Keith Mair on 4/8/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outletes
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    
    // MARK: - Properties
    var movie: Results? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Helper functions
    func updateViews() {
        
        guard let movie = movie
        else { return }
        
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "Rating: \(movie.rating)"
        movieSummaryLabel.text = movie.summary
        
        guard let poster = movie.poster
        else {
            moviePosterImage.image = UIImage(systemName: "photo.on.rectangle")
            return
        }
    
        MovieController.fetchMovie(poster: poster) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posterImage):
                    self.moviePosterImage.image = posterImage
                    
                case .failure(let error):
                    self.moviePosterImage.image = UIImage(systemName: "photo.on.rectangle")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
} // End of class
