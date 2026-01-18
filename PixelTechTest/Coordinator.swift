//
//  Coordinator.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//
import UIKit

protocol Coordinator {
    func start()
    var navigationController: UINavigationController { get }
}

class MainCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let usersListViewModel = UsersListViewModel(networkService: NetworkService())
        let usersListViewController = UsersListViewController(viewModel: usersListViewModel)
        navigationController.pushViewController(usersListViewController, animated: true)
    }
    
    
}
