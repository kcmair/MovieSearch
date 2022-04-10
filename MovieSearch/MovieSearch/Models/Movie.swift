//
//  Movie.swift
//  MovieSearch
//
//  Created by Keith Mair on 4/8/22.
//

import Foundation

struct Movie: Decodable {
    let results: [Results]
} // End of struct

struct Results: Decodable {
    let summary: String
    let poster: String?
    let title: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case summary = "overview"
        case poster = "poster_path"
        case title = "title"
        case rating = "vote_average"
    } // End of enum
} // End of struct
