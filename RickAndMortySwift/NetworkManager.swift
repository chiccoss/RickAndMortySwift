//
//  NetworkManager.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import Foundation


class NetworkManager {
    static let staticNetworkManager = NetworkManager()
    
    private let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
    
    
    private init() { }
    
    
    private static let iso8601Formatter : ISO8601DateFormatter = {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime,
                                       .withFractionalSeconds]
        
        return dateFormatter
        
    }()
    
    func fetchCharacters(completion: @escaping (Result<PaginatedElements<Character>,Error>) -> Void){
        
        let url = baseUrl.appendingPathComponent("character")
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){ (data ,urlResponse ,error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ApiError.statusCode(httpResponse.statusCode)))
                return
            }
            
            guard let mimeType = httpResponse.mimeType,
                  mimeType == "application/json" else {
                completion(.failure(ApiError.mimeTypeError))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.emptyResponse))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .custom{ (decoder) -> Date in
                    let dateString = try decoder.singleValueContainer().decode(String.self)
                    return NetworkManager.iso8601Formatter.date(from: dateString)!
                }
                
                let result = try jsonDecoder.decode(PaginatedElements<Character>.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
}
