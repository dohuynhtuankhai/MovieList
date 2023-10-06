//
//  MoviesRepositoryPreview.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation
import Combine

final class MoviesServicePreview: MoviesServiceProtocol {
    var movies: [Movie] = []
    
    func getMovies(searchTerm: String?) -> AnyPublisher<[Movie], Never> {
        return Just(movies).eraseToAnyPublisher()
    }
}
