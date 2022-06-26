//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

protocol NetworkManagerProtocol {
    func getLaunches(completion: @escaping (Result<[Launch], TLCError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    /**
     * Fetch list of launches from API. Will Return a Result set type containing an array of launches or an error if encountered.
     *  - Parameters:
     *      - completion: handler to invoke passing the result type which is either a list of launches or an error.
     */
    func getLaunches(completion: @escaping (Result<[Launch], TLCError>) -> Void) {
        guard let launchURL = URL(string: Network.baseURL + Network.launch) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: launchURL) { data, response, error in
            
            // if error is present
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            // if response status is not OK
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // if data is nil
            guard let data = data else {
                completion(.failure(.nilData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let launches = try decoder.decode([Launch].self, from: data)
                
                completion(.success(launches))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
}
