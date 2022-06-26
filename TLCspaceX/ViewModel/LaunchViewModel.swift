//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchViewModel {
    let name: String
    
    init(launch: Launch) {
        self.name = launch.name
    }
}
