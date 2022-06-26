//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct RocketInfoViewModel {
    let name: String
    let id: String
    let wikipedia: String
    
    init(rocket: Rocket) {
        self.name = rocket.name
        self.id = rocket.id
        self.wikipedia = rocket.wikipedia
    }
}
