//
//  FirebaseService.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

final class FirestoreService {
    
    let personalThoughtObservable = PublishSubject<Idea>()
    
    func createNewUser(authData : UserAuthModel) async throws {
        var userData : [String : Any] = [
            "user_id" : authData.uid,
            "email" : authData.email
        ]
        
        do {
            try await Firestore.firestore().collection("users").document(authData.uid).setData(userData, merge: false)
            //TODO: Possible tambahin observer
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
//    func getUser(for id : String) async throws {
//        let snapshot = try await Firestore.firestore().collection("users").document(id).getDocument()
//        // TODO: Bikin model profile buat halaman profile nanti ambil data dari sini
//    }
    
    func getCurrentUser() throws -> UserDatabaseModel{
        guard let user = Auth.auth().currentUser else {throw URLError.init(.notConnectedToInternet)} // TODO: Error Handling
        return UserDatabaseModel(from: user)
    }
    
    private func createDatabasePath(for data : DataBaseThoughtInputModel) -> String {
        let user = data.user
        let userPath = "/users/\(user.uid)"
        let philosopher = data.philosopher
        let philosopherPath = "/philosophers/\(philosopher.name)"
        let idea = data.idea
        let ideaPath = "/ideas/\(idea.idea)"
        let thoughtPath = "/thoughts/"
        return userPath + philosopherPath + ideaPath + thoughtPath
    }
    
    private func createDatabasePathForIdea (philosopher : PhilosopherDataBaseModel, idea : IdeasDatabaseModel) -> String {
        var databasePath : String = ""
        do {
            let currentUser = try getCurrentUser()
            let userPath = "/users/\(currentUser.uid)"
            let philosopherPath = "/philosophers/\(philosopher.name)"
            let ideaPath = "/ideas/\(idea.idea)"
            let thoughtPath = "/thoughts/"
            databasePath = userPath + philosopherPath + ideaPath + thoughtPath
        }
        catch (let err){
            print(err.localizedDescription)
        }
        return databasePath
    }
    
    // MARK: -- CRUD Personal Thought --
    func createNewThought (for data : DataBaseThoughtInputModel) throws {
        // TODO: Masing-masing dari user, philosopher, idea bikin documentny dl
        let documentPath = createDatabasePath(for: data)
        do {
            try Firestore.firestore().collection(documentPath).document(data.thought.id).setData(from: data.thought, merge: false)
            //TODO: Possible tambahin observer
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
    func fetchThought(for philosoper : PhilosopherDataBaseModel, idea : IdeasDatabaseModel) async throws{
        let documentPath = createDatabasePathForIdea(philosopher: philosoper, idea: idea)
        var personalThoughts : [PersonalThoughtModel] = []
        do {
            let existingDocumentSnapshot = try await Firestore.firestore().collection(documentPath).getDocuments()
            for document in existingDocumentSnapshot.documents {
                let currentData = try document.data(as: PersonalThoughtModel.self)
                personalThoughts.append(currentData)
            }
            let ideaOutputModel = Idea(idea: idea.idea, personalThoughts: personalThoughts)
            personalThoughtObservable.onNext(ideaOutputModel)
        }
        catch (let err){
            print(err.localizedDescription)
//            personalThoughtObservable.onError(err)
        }
    }
    
    func updateThought (
        philosopher : PhilosopherDataBaseModel,
        idea : IdeasDatabaseModel,
        existingThought : PersonalThoughtDataBaseModel,
        newThought : PersonalThoughtDataBaseModel
    ) async throws {
        let documentPath = createDatabasePathForIdea(philosopher: philosopher, idea: idea)
        let updatingFields : [String : Any] = ["id" : newThought.id, "content" : newThought.content]
        do {
            try await Firestore.firestore().collection(documentPath).document(existingThought.id).updateData(updatingFields)
            try await fetchThought(for: philosopher, idea: idea)
            //TODO: Possible tambahin observer
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
    func deleteThought (
        philosopher : PhilosopherDataBaseModel,
        idea : IdeasDatabaseModel,
        deleting : PersonalThoughtDataBaseModel
    ) async throws {
        let documentPath = createDatabasePathForIdea(philosopher: philosopher, idea: idea)
        do {
            try await Firestore.firestore().collection(documentPath).document(deleting.id).delete()
            try await fetchThought(for: philosopher, idea: idea)
            //TODO: Possible tambahin observer
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    // MARK: --
    
}
