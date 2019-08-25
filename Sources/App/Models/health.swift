//
//  health.swift
//  App
//
//  Created by Steven Prichard on 8/24/19.
//

import Foundation
import Vapor

enum ServerStatus: String, Codable {
    case booting
    case healthy
    case offline
}

struct Health: Content {
    var status: ServerStatus = .booting
    
    init(status: ServerStatus) {
        self.status = status
    }
}
