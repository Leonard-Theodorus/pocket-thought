//
//  PhilosopherDetailViewModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import Foundation
import UIKit
import RxSwift

final class PhilosopherDetailViewModel {
    // MARK: -- Services --
    let databaseService : FirestoreService
    let personalThoughtsObservable : PublishSubject<Idea>
    let disposeBag = DisposeBag()
    
    // MARK: -- Delegates --
    var viewDelegate: PhilosopherDetailViewModelViewDelegate?
    var coordinatorDelegate : PhilosopherDetailCoordinatorViewModelDelegate?
    
    // MARK: -- States --
    var philosopherData : Philosopher!
    
    init(databaseService : FirestoreService, observable : PublishSubject<Idea>) {
        self.databaseService = databaseService
        self.personalThoughtsObservable = observable
    }
    
}
extension PhilosopherDetailViewModel : PhilosopherDetailInputDelegate {
    
    // MARK: Handles view controller inputs (Implementations)
    
    
    func itemCount() -> Int {
        return philosopherData.ideas.count
    }
    
    func itemForIndex(index: Int) -> Idea {
        return philosopherData.ideas[index]
    }
    
    func itemCountAtSection(at section: Int) -> Int {
        return philosopherData.ideas[section].isExpanded ? philosopherData.ideas[section].personalThoughts.count : 0
    }
    
    func childItemForSection(section: Int) -> [PersonalThoughtModel] {
        return philosopherData.ideas[section].personalThoughts
    }
    
    
    func switchToggle(for section: Int) {
        philosopherData.ideas[section].isExpanded.toggle()
    }
    
    func getAllPersonalThoughts () {
        var count = 0
        var fetchedIdeas : [Idea] = []
        personalThoughtsObservable
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe {[weak self] event in
                guard let self else {return }
                switch event {
                    case .next(let fetchedIdea):
                        count += 1
                        fetchedIdeas.append(fetchedIdea)
                        if count == philosopherData.ideas.count {
                            philosopherData.ideas = fetchedIdeas
                            viewDelegate?.didFinishFetchingPersonalThoughts()
                        }
                        break
                    case .error(let err):
                        print(err.localizedDescription)
                    case .completed:
                        break
                }
            }
            .disposed(by: disposeBag)
        Task {
            for idea in philosopherData.ideas {
                let philosopherDataModel = PhilosopherDataBaseModel(name: philosopherName())
                let ideaDataModel = IdeasDatabaseModel(idea: idea.idea)
                try await databaseService.fetchThought(for: philosopherDataModel, idea: ideaDataModel)
            }
        }
    }
    
    func beginAddingThoughts(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, from vc : UIViewController) {
        // MARK: Prepare presenting personal thoughts sheet
        coordinatorDelegate?.goToPersonalThoughtsForAdding(philosoperData: philosoperData, ideaData: ideaData,from: vc)
    }
    
    func beginEditingThoughts(philosoperData: PhilosopherDataBaseModel, ideaData: IdeasDatabaseModel, thought : PersonalThoughtDataBaseModel, from vc: UIViewController) {
        coordinatorDelegate?.goToPersonalThoughtsForEditing(philosoperData: philosoperData, ideaData: ideaData, thought: thought, from: vc)
    }
    
    func deleteThought(philosoperData: PhilosopherDataBaseModel, ideaData: IdeasDatabaseModel, thought: PersonalThoughtDataBaseModel) {
        Task {
            try await databaseService.deleteThought(philosopher: philosoperData, idea: ideaData, deleting: thought)
            // TODO: subscribe observer + reload data per section ke view controller
        }
    }
    
    func philosopherImage() -> UIImage {
        philosopherData.photo
    }
    
    func philosopherName() -> String {
        philosopherData.name
    }
    
    
    func philosopherShortDescription() -> String {
        let philosopherName = philosopherName()
        let philosopherBornDate = philosopherData.bornDate
        let philosopherDeathDate = philosopherData.deathDate
        let nationality = philosopherData.nationality
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-DD"
        
        let transformedBornDate = inputDateFormatter.date(from: philosopherBornDate)
        let transformedDeathDate = inputDateFormatter.date(from: philosopherDeathDate)
        
        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "DD MMMM YYYY"
        
        let outputBornDate = outputDateFormat.string(from: transformedBornDate!)
        let outputDeathDate = outputDateFormat.string(from: transformedDeathDate!)
        
        var resultingString = "\(philosopherName) was a \(nationality) philosopher, was born on \(outputBornDate) and died on \(outputDeathDate). \(philosopherName)'s works mainly contributed in these following school of thoughts: "
        for i in 0 ..< philosopherData.school.count {
            if i != philosopherData.school.count - 1 {
                resultingString += "\(philosopherData.school[i]), "
            }
            else{
                resultingString += "\(philosopherData.school[i])"
            }
        }
        resultingString += ". A few of \(philosopherName)'s famous ideas are as follows:"
        
        return resultingString
    }
    
}

protocol PhilosopherDetailViewModelViewDelegate : AnyObject {
    func didFinishFetchingPersonalThoughts ()
}

protocol PhilosopherDetailInputDelegate : AnyObject {
    var viewDelegate : PhilosopherDetailViewModelViewDelegate? {get set}

    // MARK: -- Events --
    func beginAddingThoughts(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, from vc : UIViewController)
    func beginEditingThoughts(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, thought : PersonalThoughtDataBaseModel, from vc : UIViewController)
    func deleteThought(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, thought : PersonalThoughtDataBaseModel)
    
    // MARK: -- Data Source --
    func itemCount() -> Int
    func itemCountAtSection(at section : Int) -> Int
    func itemForIndex(index : Int) -> Idea
    func childItemForSection(section: Int) -> [PersonalThoughtModel]
    func getAllPersonalThoughts ()
    func switchToggle(for section: Int)
    
    
    // MARK: -- VC Contents --
    func philosopherImage() -> UIImage
    func philosopherName() -> String
    func philosopherShortDescription() -> String
}

