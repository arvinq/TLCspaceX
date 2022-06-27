//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchCellViewModel {
    let name: String
    let id: String
    let launchDate: Date
    let success: Bool?
    let smallPatch: String?
    
    init(launch: Launch) {
        self.name = launch.name
        self.id = launch.id
        self.success = launch.success
        self.launchDate = launch.dateUtc.convertDateFormat()
        self.smallPatch = launch.links.patch.small
    }
    
    func getLaunchStatus() -> String {
        guard let success = success else {
            return StatusDescription.null
        }
        
        switch success {
        case true: return StatusDescription.success
        case false: return StatusDescription.failure
        }
    }
    
    func getLaunchDate() -> String {
        return self.launchDate.convertToPrintableDateFormat()
    }
}
