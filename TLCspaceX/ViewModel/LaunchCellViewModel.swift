//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchCellViewModel {
    let name: String
    let id: String
    
    init(launch: Launch) {
        self.name = launch.name
        self.id = launch.id
    }
}
