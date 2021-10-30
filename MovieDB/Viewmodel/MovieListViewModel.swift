//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation
import UIKit.UIImage

class MovieListViewModel {
    
    var results: [Movie] = []
    
    enum MovieListType {
        case popular
        case trending
    }
    
    let type: MovieListType
    
    var apiEndPoint: TMDBAPI {
        switch type {
        case .popular:
            return .popular
        case .trending:
            return .trending
        }
    }
    
    init(type: MovieListViewModel.MovieListType) {
        self.type = type
    }
    
    func fetch(_ completion: @escaping () -> Void = {}) {
        
        TMDBAPI.provider.fetch(api: apiEndPoint) { (result: Result<PaginatedMovieResponse, Error>) in
            switch result {
            case .success(let response):
                self.results = response.results
            case .failure(let error):
                debugPrint(error)
                self.results = []
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func loadImage(forUrl url: URL, completion: @escaping (UIImage) -> Void) {
        TMDBAPI.provider.loadImage(
            url: url
        ) {  image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}
