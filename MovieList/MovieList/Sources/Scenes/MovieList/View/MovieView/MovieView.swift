//
//  MovieView.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    let viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: .tinyPadding) {
            image
            VStack {
                content
                Spacer()
                favouriteButton
            }
            Spacer()
        }
        .padding(EdgeInsets(top: .tinyPadding, leading: .tinyPadding, bottom: 0, trailing: 0))
    }
}

extension MovieView {
    // MARK: - Image
    private var image: some View {
        KFImage(URL(string: viewModel.movie.imageUrl))
            .placeholder { _ in
            ProgressView()
            }
        .resizable()
        .frame(width: CGFloat.imageWidth, height: CGFloat.imageWidth / CGFloat.imageRatio)
        .cornerRadius(.regularRadius)
    }
    
    // MARK: - Conten t
    private var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.movie.trackName)
                    .font(.systemBold(size: .medium))
                    .foregroundColor(.black)
                Text(viewModel.movie.primaryGenreName)
                    .font(.systemMedium(size: .small))
                    .foregroundColor(.gray)
                Text(String(format: "%.2f \(viewModel.movie.currency)", viewModel.movie.trackPrice))
                    .font(.systemBold(size: .small))
                    .foregroundColor(.green)
            }
            Spacer()
        }
    }
    
    private var favouriteButton: some View {
        Button(action: {
             viewModel.onTapFavourite()
        }) {
            HStack {
                Spacer()
                HStack(spacing: .picoPadding) {
                    Image(systemName: viewModel.movie.isFavorite ? "heart.slash.fill" : "heart.fill")
                        .resizable()
                        .tint(.white)
                        .frame(width: .mediumSize, height: .mediumSize)
                    Text(viewModel.movie.isFavorite ? String.removeFavorite : String.addFavorite)
                        .font(.systemMedium(size: .small))
                }
                .foregroundColor(.white)
                .padding(EdgeInsets(top: .nanoPadding, leading: .smallPadding, bottom: .nanoPadding, trailing: .nanoPadding))
                .background(viewModel.movie.isFavorite ? Color.gray : Color.red)
                .cornerRadius(.regularRadius)
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Contant
private extension CGFloat {
    static let imageWidth: CGFloat = 100
    static let imageRatio: CGFloat = 2/3
    static let iconSize: CGFloat = 15
}

private extension String {
    static let addFavorite: String = "Favorite"
    static let removeFavorite: String = "Unfavorite"
}

// MARK: - Preview
struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(viewModel: .init(movie: Movie()))
    }
}
