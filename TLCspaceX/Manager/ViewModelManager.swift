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
    var bindLaunchInformation: ((LaunchInfoViewModel?)->())?
    var bindRocketInformation: ((RocketInfoViewModel?)->())?
    
    // Properties that triggers binding and updates our view
    var alertMessage: String? {
        didSet { self.presentAlert?() }
    }
    
    var launchCellViewModels: [LaunchCellViewModel] = [] {
        didSet { self.reloadCollection?() }
    }
    
    var filteredLaunchViewModels: [LaunchCellViewModel] = [] {
        didSet { self.reloadCollection?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.animateLoadView?() }
    }
    
    var launchInfoViewModel: LaunchInfoViewModel? {
        didSet { self.bindLaunchInformation?(launchInfoViewModel) }
    }
    
    var rocketInfoViewModel: RocketInfoViewModel? {
        didSet { self.bindRocketInformation?(rocketInfoViewModel) }
    }
    
    var sortDescriptor: SortDescriptor? {
        didSet { self.sortLaunchList() }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    /**
     * Returns an individual launch view model at a given index in the array.
     *  - Parameters:
     *      - index: integer passed that represents the location of the launch in the list
     */
    func getLaunchCellViewModel(on index: Int) -> LaunchCellViewModel {
        return launchCellViewModels[index]
    }
    
    /**
     * Returns an individual launch view model at a given index in the array.
     *  - Parameters:
     *      - index: integer passed that represents the location of the launch in the list
     *      - isFiltered: bool value to indicate on what list we will get the viewModel
     */
    func getLaunchCellViewModel(on index: Int, isFiltered: Bool) -> LaunchCellViewModel {
        return isFiltered ? filteredLaunchViewModels[index] : launchCellViewModels[index]
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
                var launchCellViewModels = [LaunchCellViewModel]()
                launchCellViewModels.append(contentsOf: launches.map { LaunchCellViewModel(launch: $0) })
                self.launchCellViewModels = launchCellViewModels // will trigger the reload
                self.setInitialFilteredLaunches()
            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        }
    }
    
    func getOneLaunch(for launchId: String) {
        self.isLoading = true
        self.networkManager.getLaunchInfo(for: launchId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let launch):
                self.launchInfoViewModel = LaunchInfoViewModel(launch: launch)
            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        }
    }
    
    func getOneRocket(for rocketId: String) {
        self.isLoading = true
        self.networkManager.getRocketInfo(for: rocketId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let rocket):
                self.rocketInfoViewModel = RocketInfoViewModel(rocket: rocket)
            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        }
    }
    
    func getUnfilteredLaunches() -> [LaunchCellViewModel] {
        return launchCellViewModels
    }
    
    func getFilteredLaunches() -> [LaunchCellViewModel] {
        return filteredLaunchViewModels
    }
    
    func setInitialFilteredLaunches() {
        filteredLaunchViewModels = launchCellViewModels
    }
    
    func sortLaunchList() {
        switch sortDescriptor {
        case .missionName:
            filteredLaunchViewModels.sort { $0.name < $1.name }
        case .launchDate:
            filteredLaunchViewModels.sort { $0.launchDate > $1.launchDate }
        case .none: break
        }
    }
    
    func setFilteredLaunchList(for launchStatus: MissionStatus) {
        var compareStatus: Bool?
        
        switch launchStatus {
        case .all:
            setInitialFilteredLaunches()
            return
        case .success:
            compareStatus = true
        case .fail:
            compareStatus = false
        case .null:
            compareStatus = nil
        }
        
        filteredLaunchViewModels = launchCellViewModels.filter { $0.success == compareStatus }
        sortLaunchList()
    }
    
    /// Returns our viewModel list based on the app's status if filtered is applied or not.
    func getLaunchViewModels(isFiltered: Bool) -> [LaunchCellViewModel] {
        return isFiltered ? filteredLaunchViewModels : launchCellViewModels
    }
}
