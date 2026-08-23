//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 19.08.2026.
//

import Foundation

private enum Constants {
    static let successCodeMin = 200
    static let successCodeMax = 300
}

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < Constants.successCodeMin ||
               response.statusCode >= Constants.successCodeMax {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
