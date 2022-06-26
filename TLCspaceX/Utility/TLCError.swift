//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import Foundation

enum TLCError: String, Error {
    case invalidUrl       = "Invalid Request. Please contact the administrator."
    case invalidResponse  = "Invalid Response from the server. Please try again."
    case invalidData      = "Invalid Data Received. Please try again."
    case nilData          = "No data received. Please try again at a later time"
    case unableToComplete = "Unable to complete your request. Please check your network connection and try again."
    case unableToDecode   = "Unable to decode the data. Please check if you're decoding your data correctly."
    case invalidStaticUrl = "Invalid static URL string: %@"
    case wikiError        = "Unable to read data from rocket. Please try again."
}
