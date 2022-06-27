//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

/// Easy access values used for network
enum Network {
    static let baseURL = "https://api.spacexdata.com"
    static let launch  = "v4/launches"
    static let oneLaunch = "v4/launches/%@"
    static let oneRocket = "v4/rockets/%@"
}

/// Constant values representing titles and constants on the pages in the app
enum Title {
    static let launchList    = "SpaceX Launches List"
    static let launchAlert   = "SpaceX Launch"
    static let getRocket     = "Get Rocket"
    static let getRocketWiki = "Rocket Wiki"
    static let rocketAlert   = "Rocket"
    static let sortAndFilter = "Sort | Filter"
    static let sort          = "Sort by"
    static let filter        = "Filter by"
    static let missionName   = "Mission Name"
    static let launchDate    = "Launch Date"
    static let filterButton  = "Select Filter"
    static let applyButton   = "Apply to Launch List"
}

enum StatusDescription {
    static let success = "Successful Mission"
    static let failure = "Failed Mission"
    static let null    = "Pending Mission"
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
    static let header: CGFloat = 20.0
    static let subHeader: CGFloat = 16.0
}

/// Constant values that represents Spaces used in the app
enum Space {
    static let padding: CGFloat = 8.0
    static let cornerRadius: CGFloat = 5.0
    static let adjacent: CGFloat = 14.0
    static let margin: CGFloat = 20.0
}

enum SFSymbol {
    static let filterSort = UIImage(systemName: "slider.horizontal.3")
    static let calendar   = UIImage(systemName: "calendar")
    static let alphabet   = UIImage(systemName: "textformat.abc.dottedunderline")
    static let filter     = UIImage(systemName: "line.3.horizontal.decrease.circle")
    static let sort       = UIImage(systemName: "arrow.up.arrow.down.circle")
    static let close      = UIImage(systemName: "xmark")
}

enum SortDescriptor {
    case missionName, launchDate
}
