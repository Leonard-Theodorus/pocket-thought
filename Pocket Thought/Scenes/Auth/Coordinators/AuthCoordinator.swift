//
//  AuthCoordinator.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 17/07/24.
//

import Foundation

class AuthCoordinator : Coordinator {
    // MARK: -- Dependencies --
    let authService : FirebaseAuthService
    
    // MARK: -- Init --
    init(authService: FirebaseAuthService) {
        self.authService = authService
    }
    
    var appCoordinatorDelegate : AppCoordinatorDelegate?
    
    // MARK: -- Related View Models --
    lazy var authViewModel : AuthViewModel = {
        let viewModel = AuthViewModel(authService: authService, authObservable: authService.authObservable)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    override func start() {
        
    }
    override func finish() {
        
    }
}

extension AuthCoordinator : AuthCoordinatorViewModelDelegate {
    
    func didSuccessCreateUser() {
        appCoordinatorDelegate?.didFinishSettingUp(from: self)
    }
}

protocol AuthCoordinatorViewModelDelegate : AnyObject {
    // MARK: Handles viewmodels inputs
    func didSuccessCreateUser()
}
