//
//  UsersListViewController.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//

import UIKit

enum UsersListViewState {
    case loading
    case loaded(users: [User])
    case error(message: String)
}

class UsersListViewController: UIViewController {
    
    let viewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorState()
        getData()
    }
    
    private func monitorState() {
        viewModel.viewStateUpdated = { @MainActor [weak self] newState in
            switch newState {
            case .loading:
                print("loading state ")
            case .loaded:
                print("loaded state")
            case .error(let error):
                print("error state:", error)
            }
        }
    }
    
    private func getData() {
        Task {
            await viewModel.getUsers()
        }
    }


}
class UsersListViewModel {
    
    private let networkService: NetworkServiceProtocol
    private(set) var users: [User] = []
    
    var viewStateUpdated: ((UsersListViewState) -> Void)?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    @MainActor
    func getUsers() async {
        viewStateUpdated?(.loading)
        do {
            let usersResponse: UsersResponse = try await networkService.getData(from: .users)
            self.users = usersResponse.items
            viewStateUpdated?(.loaded(users: self.users))
            print("fetched user data:", self.users)
        } catch {
            viewStateUpdated?(.error(message: "Unable to fetch from server"))
        }
    }
    
}

