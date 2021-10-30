//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation
import UIKit.UIImage

class MovieDetailViewModel {
    
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
