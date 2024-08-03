//
//  FirebaseAuthService.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 16/07/24.
//

import Foundation
import FirebaseAuth
import RxSwift

final class FirebaseAuthService {
    // MARK: Dependencies
    let authObservable = PublishSubject<UserAuthModel>()
    let databaseService : FirestoreService
    
    init(databaseService: FirestoreService) {
        self.databaseService = databaseService
    }
    
    // MARK: Sign-up email password
    func createUser(email : String, password : String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let authConfirmation = UserAuthModel(from: authResult.user)
            try await databaseService.createNewUser(authData: authConfirmation)
            NotificationCenter.default.post(name: NSNotification.Name("pocketthought.didsignup"), object: authConfirmation)
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
    // MARK: -- Sign In Providers --
    func signInUser(email : String, password : String) async throws {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let authConfirmation = UserAuthModel(from: authResult.user)
        authObservable.onNext(authConfirmation)
    }
    
    func signInWithGoogle() async throws{
        
    }
    
    func signInWithApple() async throws {
        
    }
    
    // MARK: Check user logged in
    func isLoggedIn () -> Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func logOffCurrentUser () {
        do {
            try Auth.auth().signOut()
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
}
