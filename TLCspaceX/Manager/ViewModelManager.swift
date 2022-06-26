//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

class ViewModelManager {
    
    var networkManager: NetworkManagerProtocol
    
    // bindings, implementation of the bindings are found in the viewController
    var presentAlert: (()->())?
    var reloadCollection: (()->())?
    var animateLoadView: (()->())?
    
    // Properties that triggers binding and updates our view
    var alertMessage: String? {
        didSet { self.presentAlert?() }
    }
    
    var launchViewModels: [LaunchViewModel] = [] {
        didSet { self.reloadCollection?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.animateLoadView?() }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    /**
     * Returns an individual launch view model at a given index in the array.
     *  - Parameters:
     *      - index: integer passed that represents the location of the launch in the list
     */
    func getLaunchViewModel(on index: Int) -> LaunchViewModel {
        return launchViewModels[index]
    }
    
    /**
     * Main entry point that communicates with NetworkManager to fetch the launches and trigger an update to the collectionView
     */
    func getLaunches() {
        self.isLoading = true
        self.networkManager.getLaunches { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let launches):
                var launchViewModels = [LaunchViewModel]()
                launchViewModels.append(contentsOf: launches.map { LaunchViewModel(launch: $0) })
                self.launchViewModels = launchViewModels // will trigger the reload
                
            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        }
    }
}
