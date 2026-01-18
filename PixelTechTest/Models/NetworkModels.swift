//
//  NetworkModels.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//
import Foundation

fileprivate let baseURL = "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow"

enum Endpoint {
    case users
}
extension Endpoint {
    func asURLRequest() -> URLRequest? {
        if let url = URL(string: baseURL) {
            return URLRequest(url: url)
        }
        return nil
    }
}

struct UsersResponse: Decodable {
    let items: [User]
}

struct User: Decodable {
    let ID: Int
    let profileImage: URL?
    let displayName: String
    let reputation: Int
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case displayName = "display_name"
        case ID = "user_id"
        case reputation
    }
}
