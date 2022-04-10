//
//  MovieController.swift
//  MovieSearch
//
//  Created by Keith Mair on 4/8/22.
//

import Foundation
import UIKit

class MovieController {
    
    // MARK: - String constants
    static let baseSearchURL = URL(string: "https://api.themoviedb.org")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    static let apiKeyKey = "api_key"
    static let apiKeyValue = "2ca3f2393058aa18594ca0c91bceda6e"
    static let queryComponent = "query"
    static let baseImageURL = URL(string: "https://image.tmdb.org")
    static let tComponent = "t"
    static let pComponent = "p"
    static let sizeComponent = "w185"
    
    // Search
    // https://api.themoviedb.org/3/search/movie?api_key={api_key}&query={Search Phrase}
    static func fetchMoviesFrom(searchTerm: String, completion: @escaping (Result<[Results], MovieError>) -> Void) {
        
        guard let baseSearchURL = baseSearchURL
        else { return completion(.failure(.invalidURL)) }
        let versionURL = baseSearchURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let searchQuery = URLQueryItem(name: queryComponent, value: searchTerm)
        components?.queryItems = [apiQuery, searchQuery]
        
        guard let finalURL = components?.url
        else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE:", response.statusCode)
                }
            }
            guard let data = data
            else { return completion(.failure(.noData)) }
            
            do{
                let topLevelObject = try JSONDecoder().decode(Movie.self, from: data)
                let moviesDict = topLevelObject.results
                
                var listOfMovies: [Results] = []
                
                for movie in moviesDict {
                    listOfMovies.append(movie)
                }
                
                return completion(.success(listOfMovies))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        } .resume()
    }
    
    // Get movie image
    //https://image.tmdb.org/t/p/w185/{Poster Path}
    static func fetchMovie(poster: String, completion: @escaping (Result<UIImage, MovieError>) -> Void) {
        
        guard let baseImageURL = baseImageURL
        else { return completion(.failure(.invalidURL)) }
        let tURL = baseImageURL.appendingPathComponent(tComponent)
        let pURL = tURL.appendingPathComponent(pComponent)
        let sizeURL = pURL.appendingPathComponent(sizeComponent)
        let finalURL = sizeURL.appendingPathComponent(poster)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("POST STATUS CODE:", response.statusCode)
                }
            }
            
            guard let data = data
            else { return completion(.failure(.noData)) }
            
            do {
                let posterImage = UIImage(data: data)
                
                if let posterImage = posterImage {
                    return completion(.success(posterImage))
                    
                } else {
                    return completion(.failure(.unableToDecode))
                }
            }
        } .resume()
    }
} // End of class

