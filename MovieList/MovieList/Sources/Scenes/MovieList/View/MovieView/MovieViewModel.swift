//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation

extension MovieView {
    final class ViewModel: ObservableObject {
        let movie: Movie
        let onTapFavourite: (() -> Void)
        
        init(movie: Movie,
             onTapFavourite: @escaping (() -> Void) = {}) {
            self.movie = movie
            self.onTapFavourite = onTapFavourite
        }
    }
}
