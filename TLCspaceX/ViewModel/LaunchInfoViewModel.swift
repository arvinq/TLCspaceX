//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchInfoViewModel {
    let name: String
    let id: String
    let rocketId: String
    
    init(launch: Launch) {
        self.name = launch.name
        self.id = launch.id
        self.rocketId = launch.rocket
    }
}
