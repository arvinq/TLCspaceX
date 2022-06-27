//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchCellViewModel {
    let name: String
    let id: String
    let launchDate: Date
    let success: Bool?
    
    init(launch: Launch) {
        self.name = launch.name
        self.id = launch.id
        self.success = launch.success
        self.launchDate = launch.dateUtc.convertDateFormat()
    }
}
