//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct Rocket: Codable {
    let id: String
    let name: String
    let wikipedia: String
    let description: String
    let flickrImages: [String]
    let company: String
    let boosters: Int
    let successRatePct: Int
//    let height: Height
//    let diameter: Diameter
//    let mass: Mass
//    let engines: Engines
}
