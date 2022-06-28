//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

/// Easy access values used for network
enum Network {
    static let baseURL         = "https://api.spacexdata.com"
    static let launch          = "v4/launches"
    static let oneLaunch       = "v4/launches/%@"
    static let oneRocket       = "v4/rockets/%@"
    static let youtubeThumbBaseURL = "https://i.ytimg.com"
    static let youtubeThumbPath    = "vi/%@/hqdefault.jpg"
    
}

/// Constant values representing titles and constants on the pages in the app
enum Title {
    static let launchList    = "Launches"
    static let launchInfo    = "Launch Information"
    static let launchAlert   = "Launch"
    static let getRocket     = "View Rocket Info"
    static let getRocketWiki = "Navigate to Wikipage"
    static let rocketInfo    = "Rocket Information"
    static let rocketAlert   = "Rocket"
    static let sortAndFilter = "Sort | Filter"
    static let sort          = "Sort:"
    static let filter        = "Filter:"
    static let missionName   = "Mission Name"
    static let launchDate    = "Launch Date"
    static let filterButton  = "Select Filter"
    static let applyButton   = "Apply Changes"
}

enum Caption {
    static let detailCaption      = "Details"
    static let descriptionCaption = "Description"
    static let dateCaption        = "Launch Date"
    static let statusCaption      = "Mission Status"
    static let patchCaption       = "Official Patch"
    static let boosterCaption     = "Number of booster"
    static let successRateCaption = "Success Rate percentage"
}

enum StatusDescription {
    static let success = "Successful Mission"
    static let failure = "Failed Mission"
    static let null    = "Pending Mission"
    static let successDet = "Successful mission launch"
    static let failureDet = "Mission launch failed"
    static let nullDet    = "Upcoming mission. Details can't be determined at this time"
}

enum MissionStatus: String {
    case all = "All Mission launches"
    case success = "Successful Missions"
    case fail = "Failed Missions"
    case null = "Upcoming Missions"
}

/// Constant values to be used for animations
enum Animation {
    static let duration: CGFloat = 0.35
}

/// Easy access values to control the alpha properties for the UIElements in the app
enum Alpha {
    static let none: CGFloat       = 0.0
    static let weakFade: CGFloat   = 0.3
    static let mid: CGFloat        = 0.5
    static let strongFade: CGFloat = 0.8
    static let solid: CGFloat      = 1.0
}

/// Alert button texts
enum AlertButton {
    static let okay = "Okay"
    static let cancel = "Cancel"
}

/// Constant values that represents Sizes used in the app
enum Size {
    static let separatorHeight: CGFloat = 1.0
    static let buttonHeight: CGFloat = 44.0
}

enum FontSize {
    static let header: CGFloat = 16.0
    static let subHeader: CGFloat = 14.0
}

/// Constant values that represents Spaces used in the app
enum Space {
    static let padding: CGFloat = 8.0
    static let cornerRadius: CGFloat = 5.0
    static let adjacent: CGFloat = 14.0
    static let sameGroupAdjacent: CGFloat = 2.0
    static let margin: CGFloat = 20.0
}

enum SFSymbol {
    static let filterSort = UIImage(systemName: "slider.horizontal.3")
    static let calendar   = UIImage(systemName: "calendar")
    static let alphabet   = UIImage(systemName: "textformat.abc.dottedunderline")
    static let filter     = UIImage(systemName: "line.3.horizontal.decrease.circle")
    static let sort       = UIImage(systemName: "arrow.up.arrow.down.circle")
    static let close      = UIImage(systemName: "xmark")
    static let chevron    = UIImage(systemName: "chevron.forward")
}

enum SortDescriptor {
    case missionName, launchDate
}
