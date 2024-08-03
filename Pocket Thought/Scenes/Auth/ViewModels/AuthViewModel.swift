//
//  AuthViewModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 17/07/24.
//

import Foundation
import RxSwift

final class AuthViewModel {
    // MARK: Services / Dependency
    let authService : FirebaseAuthService
    let authObservable : PublishSubject<UserAuthModel>
    let disposeBag : DisposeBag = DisposeBag()
    
    // MARK: Delegates
    var coordinatorDelegate : AuthCoordinatorViewModelDelegate?
    var viewDelegate : AuthViewModelViewDelegate?
    
    init(authService: FirebaseAuthService, authObservable : PublishSubject<UserAuthModel>) {
        self.authService = authService
        self.authObservable = authObservable
    }
    
    @objc private func notificationDidSignUp(notification : NSNotification) {
        let authData = notification.object as! UserAuthModel
        viewDelegate?.didSucessCreateUser(user: authData)
        coordinatorDelegate?.didSuccessCreateUser()
    }
    
}

extension AuthViewModel : AuthViewModelInputDelegate {
    
    func didTapSignUp(email: String, password: String) {
        Task{
            try await authService.createUser(email: email, password: password)
        }
    }
    
    func didTapSignInWithEmail(email: String, password: String) {
        authObservable
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(on: MainScheduler())
            .subscribe { event in
            switch event {
                case .next(let authModel):
                    // TODO: Ini self gpp?
                    print("Output From RxSwift: \(authModel)")
                    self.viewDelegate?.didSucessSignInUser(user: authModel)
                    self.coordinatorDelegate?.didSuccessCreateUser()
                    break
                case .error(let err):
                    print(err.localizedDescription)
                case .completed:
                    break
            }
        }
        .disposed(by: disposeBag)
        
        Task{
            try await authService.signInUser(email: email, password: password)
        }
    }
    
    func didTapSignInWithGoogle() {
        // TODO: Sign in with google
    }
    
    func didTapSignInWithApple() {
        // TODO: Sign in with apple
    }
    func didTapLogOff() {
        authService.logOffCurrentUser()
    }
    func isAuthenticated() -> Bool {
        authService.isLoggedIn()
    }
    
    func start() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notificationDidSignUp),
                                               name: NSNotification.Name("pocketthought.didsignup"),
                                               object: nil)
        
    }
    
    func finish() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pocketthought.didsignup"), object: nil)
    }
    
}

protocol AuthViewModelViewDelegate : AnyObject {
    // MARK: Handles Services Output
    func didSucessCreateUser(user : UserAuthModel)
    func didSucessSignInUser(user : UserAuthModel)
}

protocol AuthViewModelInputDelegate : AnyObject {
    // MARK: Handles view inputs
    var viewDelegate : AuthViewModelViewDelegate? {get set}
    
    // MARK: -- Events --
    func isAuthenticated() -> Bool
    func didTapSignUp(email : String, password : String)
    func didTapSignInWithEmail (email : String, password : String)
    func didTapSignInWithGoogle()
    func didTapSignInWithApple()
    func didTapLogOff()
    
    // MARK: -- Lifecycle --
    func start()
    func finish()
}
