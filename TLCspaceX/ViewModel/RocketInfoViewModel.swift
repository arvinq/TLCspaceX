//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct RocketInfoViewModel {
    let name: String
    let id: String
    let wikipedia: String
    let rocketImageURL: String
    let company: String
    let description: String
    let booster: String
    let successRatePct: String
    
    init(rocket: Rocket) {
        self.name = rocket.name
        self.id = rocket.id
        self.wikipedia = rocket.wikipedia
        self.rocketImageURL = rocket.flickrImages[0]
        // we're getting the first one of the flicker image.
        self.company = rocket.company
        self.description = rocket.description
        self.booster = "\(rocket.boosters) boosters"
        self.successRatePct = "\(rocket.successRatePct)% success"
    }
    
    
}
