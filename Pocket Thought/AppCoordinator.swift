//
//  AppCoordinator.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 04/07/24.
//

import Foundation
import UIKit
import FirebaseCore

class AppCoordinator : Coordinator{
    
    let window : UIWindow?
    
    // MARK: Coordinators
    let philosopherCoordinator : PhilosopherCoordinator
    let authCoordinator : AuthCoordinator
    
    var rootVc : UINavigationController!
    
    // MARK: Services
    let APIService : APIService
    let authService : FirebaseAuthService
    let databaseService : FirestoreService
    
    init(window: UIWindow?) {
        self.window = window
        self.APIService = Pocket_Thought.APIService()
        self.databaseService = FirestoreService()
        self.authService = FirebaseAuthService(databaseService: databaseService)
        
        self.philosopherCoordinator = PhilosopherCoordinator(apiService: APIService, databaseService: databaseService)
        self.authCoordinator = AuthCoordinator(authService: authService)
    }
    
    override func start() {
        FirebaseApp.configure()
        self.philosopherCoordinator.appCoordinatorDelegate = self
        self.authCoordinator.appCoordinatorDelegate = self
        philosopherCoordinator.start()
    }
    
    private func setUpLoggedInWindow(){
        guard let window else {return}
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            let philosopherVc = PhilosopherViewController()
            philosopherVc.viewModel = philosopherCoordinator.philosopherViewModel
            rootVc = UINavigationController(rootViewController: philosopherVc)
            window.rootViewController = rootVc
            window.makeKeyAndVisible()
        }
    }
    
    private func setupAuthWindow () {
        guard let window else {return}
        DispatchQueue.main.async { [weak self] in
            guard let self else {return }
            let authVc = AuthViewController()
            authVc.viewModel = authCoordinator.authViewModel
            rootVc = UINavigationController(rootViewController: authVc)
            window.rootViewController = rootVc
            window.makeKeyAndVisible()
        }
    }
    
    override func finish() {
        
    }
}

extension AppCoordinator : AppCoordinatorDelegate {
    
    func didFinishSettingUp(from coordinator: Coordinator) {
        if (coordinator === self.philosopherCoordinator || coordinator === self.authCoordinator) && authService.isLoggedIn() {
            setUpLoggedInWindow()
        }
        else if coordinator === self.philosopherCoordinator && !authService.isLoggedIn() {
            setupAuthWindow()
        }
    }
    
}
