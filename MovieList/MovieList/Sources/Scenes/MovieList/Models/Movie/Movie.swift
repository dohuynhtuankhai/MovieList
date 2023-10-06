//
//  Movie.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation

struct Movie: Decodable, Identifiable {
    var id: Int
    let trackName: String
    var isFavorite: Bool = false
    let primaryGenreName: String
    let imageUrl: String
    let longDescription: String
    let trackPrice: Double
    let currency: String
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        case primaryGenreName
        case artworkUrl100
        case longDescription
        case trackPrice
        case currency
    }
    
    // MARK: - Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .trackId)
        trackName = try container.decode(String.self, forKey: .trackName)
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? ""
        imageUrl = try container.decode(String.self, forKey: .artworkUrl100)
        longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription) ?? ""
        trackPrice = try container.decodeIfPresent(Double.self, forKey: .trackPrice) ?? 0
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
    }
    
    init(id: Int = -1,
         trackName: String = "",
         isFavorite: Bool = false,
         primaryGenreName: String = "",
         imageUrl: String = "",
         longDescription: String = "",
         trackPrice: Double = 0,
         currency: String = "") {
        self.id = id
        self.trackName = trackName
        self.isFavorite = isFavorite
        self.primaryGenreName = primaryGenreName
        self.imageUrl = imageUrl
        self.longDescription = longDescription
        self.trackPrice = trackPrice
        self.currency = currency
    }
    
    init(entity: FavoriteMovieEnity) {
        self.id = Int(entity.trackId)
        self.trackName = entity.trackName ?? ""
        self.isFavorite = entity.isFavorite
        self.primaryGenreName = entity.primaryGenreName ?? ""
        self.imageUrl = entity.imageUrl ?? ""
        self.longDescription = entity.longDescription ?? ""
        self.trackPrice = entity.trackPrice
        self.currency = entity.currency ?? ""
    }
}
