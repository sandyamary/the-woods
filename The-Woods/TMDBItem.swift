//
//  TMDBItem.swift
//  The-Woods
//
//  Created by Udumala, Mary on 3/26/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

struct TMDBItem {
    
    // MARK: Properties
    
    let title: String
    let id: Int
    let rating: Float?
    let ratingCount: Int?
    let posterPath: String?
    let releaseYear: String?
    
    // MARK: Initializers
    
    // construct a TMDBItem from a dictionary
    init(dictionary: [String:AnyObject]) {
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        
        rating = dictionary[TMDBClient.JSONResponseKeys.MovieRating] as! Float
        ratingCount = dictionary[TMDBClient.JSONResponseKeys.MovieRatingCount] as! Int
        
        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String, releaseDateString.isEmpty == false {
            releaseYear = releaseDateString.substring(to: releaseDateString.characters.index(releaseDateString.startIndex, offsetBy: 4))
        } else {
            releaseYear = ""
        }
    }
    
    static func moviesFromResults(_ results: [[String:AnyObject]]) -> [TMDBItem] {
        
        var movies = [TMDBItem]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            movies.append(TMDBItem(dictionary: result))
        }
        
        return movies
    }
}

// MARK: - TMDBItem: Equatable

extension TMDBItem: Equatable {}

func ==(lhs: TMDBItem, rhs: TMDBItem) -> Bool {
    return lhs.id == rhs.id
}

