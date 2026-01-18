//
//  PixelTechTestTests.swift
//  PixelTechTestTests
//
//  Created by Phil Margetson on 18/01/2026.
//

import Testing
import Foundation

@testable import PixelTechTest

struct UserListViewModelTests {

    @Test @MainActor func testGetUsersSuccess() async throws {
        let mockUserData = [User(ID: 1, profileImage: nil, displayName: "John", reputation: 67), User(ID: 2, profileImage: nil, displayName: "Bill", reputation: 500)]
        let response = UsersResponse(items: mockUserData)
        clearDefaultsForTesting(functionName: #function)
        
        let networkService = MockNetworkService()
        networkService.addSuccessResponse(response, for: .users)
        
        //test of state transitions
        var receivedViewStates = [UsersListViewState]()
        let userListViewModel = UsersListViewModel(networkService: networkService, followingDatastore: FollowingDatastore(suiteName: #function))
        userListViewModel.viewStateUpdated = { newState in
            receivedViewStates.append(newState)
        }
        await userListViewModel.getUsers()
        #expect(receivedViewStates == [.loading, .loaded(users: mockUserData)])
    }
    
    @Test @MainActor func testGetUsersFailure() async throws {
       
        //test of state transitions and error propagation to VM
        clearDefaultsForTesting(functionName: #function)
        let networkService = MockNetworkService()
        networkService.addErrorResponse(NetworkError.badResponse, for: .users)
        let userListViewModel = UsersListViewModel(networkService: networkService, followingDatastore: FollowingDatastore(suiteName: #function))
        var receivedViewStates: [UsersListViewState] = []
        userListViewModel.viewStateUpdated = { newState in
            receivedViewStates.append(newState)
        }
        await userListViewModel.getUsers()
        #expect(receivedViewStates.count == 2)
        #expect(receivedViewStates == [.loading, .error(message: "Unable to fetch from server")])
    }
    
    @Test @MainActor func testToggleFollowDatastore() async throws {
        
        clearDefaultsForTesting(functionName: #function)
        
        let followingDatastore = FollowingDatastore(suiteName: #function)
        
        let networkService = MockNetworkService()
        let usersListViewModel = UsersListViewModel(networkService: networkService, followingDatastore: followingDatastore)
        
        let user = User(ID: 1, profileImage: nil, displayName: "John", reputation: 67)
        let secondUser = User(ID: 2, profileImage: nil, displayName: "Jane", reputation: 42)
        
        //testing to ensure that toggle is working correctly, and not applying to second user
        #expect(followingDatastore.isFollowed(userID: user.ID) == false)
        #expect(followingDatastore.isFollowed(userID: secondUser.ID) == false)
        #expect(usersListViewModel.isFollowing(user: user) == false)
        usersListViewModel.toggleFollow(for: user)
        #expect(followingDatastore.isFollowed(userID: user.ID) == true)
        #expect(followingDatastore.isFollowed(userID: secondUser.ID) == false)
        #expect(usersListViewModel.isFollowing(user: user) == true)
        usersListViewModel.toggleFollow(for: user)
        #expect(followingDatastore.isFollowed(userID: user.ID) == false)
        #expect(followingDatastore.isFollowed(userID: secondUser.ID) == false)
        #expect(usersListViewModel.isFollowing(user: user) == false)
    }
    
    private func clearDefaultsForTesting(functionName: String) {
        //remove existing configuration for suite name
        let existingSuite = UserDefaults.init(suiteName: functionName)
        existingSuite?.removePersistentDomain(forName: functionName)
    }
    

}
