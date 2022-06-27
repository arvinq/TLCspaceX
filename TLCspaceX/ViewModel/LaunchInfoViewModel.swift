//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

struct LaunchInfoViewModel {
    let name: String
    let id: String
    let rocketId: String
    let printableLaunchDate: String
    let success: Bool?
    let youtubeId: String?
    let details: String?
    
    init(launch: Launch) {
        self.name = launch.name
        self.id = launch.id
        self.rocketId = launch.rocket
        self.success = launch.success
        self.printableLaunchDate = launch.dateUtc.convertToPrintableDateFormat()
        self.youtubeId = launch.links.youtubeId
        self.details = launch.details
    }
    
    func getYoutubeThumbnailURL() -> String? {
        let youtubeThumbBaseURL = URL(Network.youtubeThumbBaseURL)
        
        if let youtubeId = youtubeId {
            let youtubeThumbPath = String(format: Network.youtubeThumbPath, youtubeId)
            let youtubeThumbURL = URL(string: youtubeThumbPath, relativeTo: youtubeThumbBaseURL)!
            return youtubeThumbURL.absoluteString
        }
        
        return nil
    }
    
    func getLaunchDetails() -> String {
        guard let details = details else { return "No details available for this specific launch." }
        return details
    }
    
    func getLaunchStatus() -> String {
        guard let success = success else {
            return StatusDescription.nullDet
        }
        
        switch success {
        case true: return StatusDescription.successDet
        case false: return StatusDescription.failureDet
        }
    }
}
