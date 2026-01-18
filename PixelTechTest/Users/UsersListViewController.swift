//
//  UsersListViewController.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//

import UIKit

class UsersListViewController: UIViewController {
    
    let usersView = UsersListView()
    let viewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = usersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "StackOverflow Users"
        monitorState()
        setupTableview()
        getData()
    }
    
    private func monitorState() {
        viewModel.viewStateUpdated = { @MainActor [weak self] newState in
            guard let self = self else { return }
            switch newState {
            case .loading:
                print("loading state")
                usersView.showSpinner()
            case .loaded(let users):
                print("loaded state. Updated users: \(users)")
                usersView.hideSpinner()
                self.usersView.tableview.reloadData()
            case .error(let error):
                usersView.showErrorMessage(error)
                print("error state:", error)
            }
        }
    }
    
    private func setupTableview() {
        usersView.tableview.dataSource = self
        usersView.tableview.delegate = self
    }
    
    private func getData() {
        Task {
            await viewModel.getUsers()
        }
    }
}
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseID) as? UserListCell else {
            return UITableViewCell()
        }
        let userAtRow = viewModel.users[indexPath.row]
        cell.update(userName: userAtRow.displayName, userReputation: String(userAtRow.reputation), userImageURL: userAtRow.profileImage, isFollowing: viewModel.isFollowing(user: userAtRow))
        cell.onFollowPressed = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleFollow(for: userAtRow)
            self.usersView.tableview.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

