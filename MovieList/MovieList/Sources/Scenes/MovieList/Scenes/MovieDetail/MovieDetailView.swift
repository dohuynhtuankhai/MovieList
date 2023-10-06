//
//  MovieDetailView.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var listViewModel: MovieListView.ViewModel
    @StateObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .regularPadding) {
                MovieView(viewModel: .init(movie: viewModel.movie, onTapFavourite: {
                    viewModel.toggleFavoriteAction()
                }))
                Divider()
                Text(viewModel.movie.longDescription)
                    .font(.system(size: .small))
                    .foregroundColor(.black)
            }
            .padding(.tinyPadding)
        }
        .onReceive(viewModel.onUpdateFavorite) { _ in
            listViewModel.fetchMovies()
        }
        .navigationTitle(String.movieDetailTitle)
    }
}

// MARK: - Constants
private extension String {
    static let movieDetailTitle = "Movie Detail"
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(viewModel: .init(movie: Movie()))
    }
}
