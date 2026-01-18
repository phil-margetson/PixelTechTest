//
//  UserDefaults.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//
import Foundation

protocol FollowingDatastoreProtocol {
    func isFollowed(userID: Int) -> Bool
    func getAllFollowedUsers() -> [Int]
    func follow(userID: Int)
    func unfollow(userID: Int)
}

final class FollowingDatastore: FollowingDatastoreProtocol {
    
    private let defaultsKey = "followedUsers"
    private let defaults: UserDefaults
    
    init(suiteName: String?) {
        defaults = UserDefaults.init(suiteName: suiteName) ?? UserDefaults.standard // allows us to specify a test suite name
    }
    
    func isFollowed(userID: Int) -> Bool {
        return getAllFollowedUsers().contains(userID)
    }
    
    func getAllFollowedUsers() -> [Int] {
        return defaults.array(forKey: defaultsKey) as? [Int] ?? []
    }
    
    func follow(userID: Int) {
        var followedUsers = getAllFollowedUsers()
        followedUsers.append(userID)
        defaults.set(followedUsers, forKey: defaultsKey)
    }
    
    func unfollow(userID: Int) {
        var followedUsers = getAllFollowedUsers()
        followedUsers.removeAll(where: {$0 == userID})
        defaults.set(followedUsers, forKey: defaultsKey)
    }
}
