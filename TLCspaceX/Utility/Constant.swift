//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

/// Easy access values used for network
enum Network {
    static let baseURL = "https://api.spacexdata.com"
    static let launch  = "v4/launches"
}

/// Constant values representing titles on the pages in the app
enum Title {
    static let launchList = "SpaceX Launches List"
    static let launcAlert = "SpaceX Launch"
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
}

/// Constant values that represents Spaces used in the app
enum Space {
    static let padding: CGFloat = 8.0
}
