//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct Launch: Codable {
    let id: String
    let name: String
    let rocket: String
    let dateUtc: String
    let success: Bool?
}

typealias Launches = [Launch]
