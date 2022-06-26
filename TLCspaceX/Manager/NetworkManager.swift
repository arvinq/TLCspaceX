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
                
                let oneRocket = try decoder.decode(Rocket.self, from: data)
                
                completion(.success(oneRocket))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
}
