//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

extension URL {
    init(_ string: String) {
        guard let url = URL(string: string) else {
            preconditionFailure(String(format: TLCError.invalidStaticUrl.rawValue, "\(string)"))
        }
        
        self = url
    }
}

