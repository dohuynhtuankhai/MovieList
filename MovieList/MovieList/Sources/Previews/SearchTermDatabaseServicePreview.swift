//
//  SearchTermDatabaseServicePreview.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import Combine

final class SearchTermDatabaseServicePreview: SearchTermDatabaseServiceProtocol {
    var searchTerms: [SearchTerm] = []
    var onSaveSearchTerm: (() -> Void) = {}
    var onDeleteSearchTerm: (() -> Void) = {}
    
    func getSearchTerms() -> AnyPublisher<[SearchTerm], Error> {
        return Result<[SearchTerm], Error> {
            return searchTerms
        }
        .publisher
        .eraseToAnyPublisher()
        
    }
    
    func saveSearchTerm(_ value: String) -> AnyPublisher<Void, Error> {
        return Result<Void, Error> {
            return onSaveSearchTerm()
        }
        .publisher
        .eraseToAnyPublisher()
    }
    
    func deleteSearchTerms(_ values: [String]) -> AnyPublisher<Void, Error> {
        return Result<Void, Error> {
            return onDeleteSearchTerm()
        }
        .publisher
        .eraseToAnyPublisher()
    }
    
    
}
