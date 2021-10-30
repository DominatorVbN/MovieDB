//
//  TMDBApiProvider.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation
import ElegantAPI
import UIKit.UIImage
 
class TMDBApiProvider {
    
    var imageCache: Cache<URL,Data> = Cache<URL,Data>.init()

    
    enum RequestError: Error {
        case unableToCreate
        case dataNotFound
    }
    
    func fetch<T: Decodable>(
        api: TMDBAPI,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let request =  api.getURLRequest() else {
            completion(.failure(RequestError.unableToCreate))
            return
        }
        NetworkLogger.log(request: request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            NetworkLogger.log(data: data, response: response, error: error)
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(RequestError.dataNotFound))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadImage(
        url: URL,
        completion: @escaping (UIImage) -> Void
    ) {
        let data = imageCache.value(forKey: url)
        if let cachedData = data,
           let image = UIImage(data: cachedData) {
            completion(image)
        } else {
            URLSession(configuration: .default).dataTask(with: url) { data, _, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.insert(data, forKey: url)
                completion(image)
            }.resume()
        }
    }
}
