//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

protocol NetworkManagerProtocol {
    func getLaunches(completion: @escaping (Result<[Launch], TLCError>) -> Void)
    func getLaunchInfo(for launchId: String, completion: @escaping (Result<Launch, TLCError>) -> Void)
    func getRocketInfo(for rocketId: String, completion: @escaping (Result<Rocket, TLCError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    /// baseURL from SpaceX
    var spacexBaseURL: URL { return URL(Network.baseURL) }
    
    static let cache = NSCache<NSString, UIImage>()
    
    /**
     * Fetch list of launches from API. Will Return a Result set type containing an array of launches or an error if encountered.
     *  - Parameters:
     *      - completion: handler to invoke passing the result type which is either a list of launches or an error.
     */
    func getLaunches(completion: @escaping (Result<[Launch], TLCError>) -> Void) {
        guard let launchURL = URL(string: Network.launch, relativeTo: spacexBaseURL) else {
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
                decoder.dateDecodingStrategy = .iso8601
                
                let launches = try decoder.decode([Launch].self, from: data)
                
                completion(.success(launches))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    /**
     * Fetch one launch from API. Will Return a Result set type containing the launch's info or an error if encountered.
     *  - Parameters:
     *      - launchId: the reference to use to query launch's information
     *      - completion: handler to invoke passing the result type which is either a the launch or an error.
     */
    func getLaunchInfo(for launchId: String, completion: @escaping (Result<Launch, TLCError>) -> Void) {
        let oneLaunchPath = String(format: Network.oneLaunch, launchId)
        
        guard let oneLaunchURL = URL(string: oneLaunchPath, relativeTo: spacexBaseURL) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: oneLaunchURL) { data, response, error in
            
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
                decoder.dateDecodingStrategy = .iso8601
                
                let oneLaunch = try decoder.decode(Launch.self, from: data)
                
                completion(.success(oneLaunch))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    /**
     * Fetch one rocket from API. Will Return a Result set type containing the rocket's info or an error if encountered.
     *  - Parameters:
     *      - rocketId: the reference to use to query rocket's information
     *      - completion: handler to invoke passing the result type which is either a rocket or an error.
     */
    func getRocketInfo(for rocketId: String, completion: @escaping (Result<Rocket, TLCError>) -> Void) {
        let oneRocketPath = String(format: Network.oneRocket, rocketId)
        
        guard let oneRocketURL = URL(string: oneRocketPath, relativeTo: spacexBaseURL) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: oneRocketURL) { data, response, error in
            
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
                decoder.dateDecodingStrategy = .iso8601
                
                let oneRocket = try decoder.decode(Rocket.self, from: data)
                
                completion(.success(oneRocket))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    /**
     * Get the image to display using the downloadUrl in the api. This returns an optional image.
     *  - Parameters:
     *      - urlString: the url to get the image resource
     *      - completion: handler to invoke passing the optional image downloaded.
     */
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        // return the image if its already in our cache
        if let image = NetworkManager.cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completion(nil)
                      return
                  }
            
            // cache our image
            NetworkManager.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        
        task.resume()
    }
}
