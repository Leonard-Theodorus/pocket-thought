//
//  PersonalThoughtViewModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation

final class PersonalThoughtViewModel {
    // MARK: Dependencies
    let databaseService : FirestoreService
    
    // MARK: Delegates
    var viewDelegate : PersonalThoughtViewModelViewDelegate?
//    var coordinatorDelegate
    
    var philosopherDatabaseItem : PhilosopherDataBaseModel
    var ideaDatabaseItem : IdeasDatabaseModel
    
    init(databaseService: FirestoreService, philosoperItem : PhilosopherDataBaseModel, ideaItem : IdeasDatabaseModel) {
        self.databaseService = databaseService
        self.philosopherDatabaseItem = philosoperItem
        self.ideaDatabaseItem = ideaItem
    }
    
    private func getCurrentUser() -> UserDatabaseModel {
        var currentUser : UserDatabaseModel!
        do{
            currentUser = try databaseService.getCurrentUser()
        }
        catch (let err){
            print(err.localizedDescription)
        }
        return currentUser
    }
}

extension PersonalThoughtViewModel : PersonalThoughtViewModelInputDelegate {
    func getPhilosopher() -> PhilosopherDataBaseModel {
        philosopherDatabaseItem
    }
    
    func getIdea() -> IdeasDatabaseModel {
        ideaDatabaseItem
    }
    
    
    func saveThought(philosopherItem : PhilosopherDataBaseModel, ideaItem : IdeasDatabaseModel, thoughtContent : String) {
        let newThoughtData = PersonalThoughtDataBaseModel(content: thoughtContent)
        let user = getCurrentUser()
        let personalThoughtData = DataBaseThoughtInputModel(user: user, philosopher: philosopherItem, idea: ideaItem, thought: newThoughtData)
        do {
            try databaseService.createNewThought(for: personalThoughtData)
            // TODO: Possible Rx here
        }
        catch (let err){
            print(err.localizedDescription)
        }
    }
    
    func editThought(philosopherItem: PhilosopherDataBaseModel, ideaItem: IdeasDatabaseModel, existingThought : PersonalThoughtDataBaseModel, thoughtContent: String) {
        let newThoughtData = PersonalThoughtDataBaseModel(content: thoughtContent)
        Task {
            do {
                try await databaseService.updateThought(philosopher: philosopherItem, idea: ideaItem, existingThought: existingThought, newThought: newThoughtData)
                // TODO: subscribe observer + reload data per section ke view controller
            }
            catch (let err) {
                print(err.localizedDescription)
            }
        }
    }
    
}


protocol PersonalThoughtViewModelViewDelegate : AnyObject {
    // MARK: Handles Output from Viewmodel to view
}

protocol PersonalThoughtViewModelInputDelegate : AnyObject {
    // MARK: Handles Input from View
    var viewDelegate : PersonalThoughtViewModelViewDelegate? {get set}
    
    // MARK: -- events --
    func saveThought(philosopherItem : PhilosopherDataBaseModel, ideaItem : IdeasDatabaseModel, thoughtContent : String)
    func editThought(philosopherItem : PhilosopherDataBaseModel, ideaItem : IdeasDatabaseModel, existingThought : PersonalThoughtDataBaseModel, thoughtContent : String)
    func getPhilosopher() -> PhilosopherDataBaseModel
    func getIdea() -> IdeasDatabaseModel
    
}
