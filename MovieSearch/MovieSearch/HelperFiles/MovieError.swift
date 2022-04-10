//
//  MovieError.swift
//  MovieSearch
//
//  Created by Keith Mair on 4/8/22.
//

import Foundation

enum MovieError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var  errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the necessary URL"
        case .thrownError(let error):
            return "Error: \(error) -- \(error.localizedDescription)"
        case.noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "Unable to decode the data."
        }
    }
} // End of enum
