//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct RocketInfoViewModel {
    let name: String
    let id: String
    
    init(rocket: Rocket) {
        self.name = rocket.name
        self.id = rocket.id
    }
}
