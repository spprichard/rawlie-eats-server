//
//  eats.swift
//  App
//
//  Created by Steven Prichard on 8/24/19.
//

import Foundation
import Vapor

enum EatStatus: String, Content {
    case acknowledged
    case error
}

struct EatEvent: Content {
    var timestamp: Date
}

struct EatEventResponse: Content {
    var status: EatStatus
    var message: String
}

struct EatStatusResponse: Content {
    var lastFeed: Date?
    var message: String
}
