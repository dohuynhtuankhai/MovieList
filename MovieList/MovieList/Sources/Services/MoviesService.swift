//
//  File.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation
import Combine

protocol MoviesServiceProtocol {
    func getMovies(searchTerm: String?) -> AnyPublisher<[Movie], Never>
}

public final class MoviesService: MoviesServiceProtocol {
    func getMovies(searchTerm: String?) -> AnyPublisher<[Movie], Never> {
        let escapedSearchTerm = searchTerm?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let moviesURL = URL(string: "https://itunes.apple.com/search?term=\(escapedSearchTerm)&country=au&media=movie")!
        return URLSession
            .shared
            .dataTaskPublisher(for: moviesURL)
            .map(\.data)
            .decode(type: MovieAPIModel.self, decoder: JSONDecoder())
            .catch { error -> Just<MovieAPIModel> in
                    print("Decoding error: \(error)")
                    return Just(MovieAPIModel(resultCount: -1, results: []))
            }
            .compactMap { response in
                return response.results
            }
            .replaceError(with: [Movie]())
            .eraseToAnyPublisher()
    }
}
