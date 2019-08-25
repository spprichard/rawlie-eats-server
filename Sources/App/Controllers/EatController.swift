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
    
    static let winnipeg: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        formatter.timeZone = TimeZone(abbreviation: "CDT")
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
    var encoder = JSONEncoder()
    var lastFeed: Date?
    
    init() {
        self.decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        self.encoder.dateEncodingStrategy = .formatted(DateFormatter.winnipeg)
        self.lastFeed = nil
    }
    
    func handle(_ req: Request) throws -> EventLoopFuture<HTTPResponse> {
        print("Handle endpoint hit.")
        let data = try req.content.decode(json: EatEvent.self, using: self.decoder)
        
        return data.map { result in
            self.lastFeed = result.timestamp
            
            let resp = EatEventResponse(status: .acknowledged, message: "Feed event recieved")
            let responseData = try self.encoder.encode(resp)
            let body = HTTPBody(data: responseData)
            
            return HTTPResponse(
                status: .accepted,
                headers: req.http.headers,
                body: body)
        }
    }
    
    func status(_ req: Request) throws -> Response {
        guard let time = self.lastFeed else {
            return try self.returnWith(message: "Rawlie hasn't been fed yet, you should feed her!", from: req)
        }
        
        
        let date = DateFormatter.winnipeg.string(from: time)
        return try returnWith(message: "Rawlie was last fed at \(date)", from: req)
    }
    
    private func returnWith(message: String, from req: Request) throws -> Response {
        let resp = EatStatusResponse(lastFeed: self.lastFeed, message: message)
        let respData = try self.encoder.encode(resp)
        let body = HTTPBody(data: respData)
        
        return req.response(body)
    }
}
