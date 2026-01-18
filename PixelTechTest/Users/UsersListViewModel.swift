//
//  UsersListViewModel.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//

enum UsersListViewState: Equatable {
    case loading
    case loaded(users: [User])
    case error(message: String)
}

class UsersListViewModel {
    
    private let networkService: NetworkServiceProtocol
    private let followingDatastore: FollowingDatastoreProtocol
    private(set) var users: [User] = []
    
    var viewStateUpdated: ((UsersListViewState) -> Void)?
    
    init(networkService: NetworkServiceProtocol, followingDatastore: FollowingDatastoreProtocol) {
        self.networkService = networkService
        self.followingDatastore = followingDatastore
    }
    
    @MainActor
    func getUsers() async {
        viewStateUpdated?(.loading)
        do {
            let usersResponse: UsersResponse = try await networkService.getData(from: .users)
            self.users = usersResponse.items
            viewStateUpdated?(.loaded(users: self.users))
        } catch {
            viewStateUpdated?(.error(message: "Unable to fetch from server"))
        }
    }
    
    func toggleFollow(for user: User) {
        if followingDatastore.isFollowed(userID: user.ID) {
            followingDatastore.unfollow(userID: user.ID)
        } else {
            followingDatastore.follow(userID: user.ID)
        }
    }
    
    func isFollowing(user: User) -> Bool {
        return followingDatastore.isFollowed(userID: user.ID)
    }
    
}
