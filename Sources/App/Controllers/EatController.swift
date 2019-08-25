//
//  EatController.swift
//  App
//
//  Created by Steven Prichard on 8/24/19.
//

import Foundation
import Vapor

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}



/// Controls basic CRUD operations on `Todo`s.
//final class TodoController {
//    /// Returns a list of all `Todo`s.
//    func index(_ req: Request) throws -> Future<[Todo]> {
//        return Todo.query(on: req).all()
//    }
//
//    /// Saves a decoded `Todo` to the database.
//    func create(_ req: Request) throws -> Future<Todo> {
//        return try req.content.decode(Todo.self).flatMap { todo in
//            return todo.save(on: req)
//        }
//    }
//
//    /// Deletes a parameterized `Todo`.
//    func delete(_ req: Request) throws -> Future<HTTPStatus> {
//        return try req.parameters.next(Todo.self).flatMap { todo in
//            return todo.delete(on: req)
//        }.transform(to: .ok)
//    }
//}

final class EatController {
    var decoder = JSONDecoder()
    
    init() {
        self.decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
    }
    
    func handle(_ req: Request) throws -> EventLoopFuture<Response> {
        print("Handle endpoint hit.")
        let data = try req.content.decode(json: EatEvent.self, using: self.decoder)
        
        return data.flatMap { result in
            return try! result.encode(for: req)
        }
    }
}
