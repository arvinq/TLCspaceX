//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

extension Date {
    /// convert string date to desired date format for output / printing
    func convertToPrintableDateFormat() -> String {
        let outDateFormatter = DateFormatter()
        outDateFormatter.dateFormat = "MMM d, yyyy"
        
        return outDateFormatter.string(from: self)
    }
}
