//
//  PhilosopherCoordinator.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 05/07/24.
//

import Foundation
import UIKit

class PhilosopherCoordinator : Coordinator {
    
    //MARK: -- Dependencies --
    let apiService : APIService
    let databaseService : FirestoreService
    
    
    //MARK: INIT
    init(apiService: APIService, databaseService : FirestoreService) {
        self.apiService = apiService
        self.databaseService = databaseService
    }
    
    //MARK: Coordinators Delegate
    var appCoordinatorDelegate : AppCoordinatorDelegate?
    
    // MARK: -- Related view-models --
    lazy var philosopherViewModel : PhilosopherViewModel = {
        let philosopherApiService = PhilosopherAPIService(apiService: apiService)
        let viewModel = Pocket_Thought.PhilosopherViewModel(apiService: philosopherApiService)
        viewModel.coordinatorDelegate = self
        philosopherApiService.delegate = viewModel
        return viewModel
    }()
    
    lazy var detailViewModel : PhilosopherDetailViewModel = {
        let viewModel = PhilosopherDetailViewModel(databaseService: databaseService, observable: databaseService.personalThoughtObservable)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    
    override func start() {
        philosopherViewModel = philosopherViewModel
        appCoordinatorDelegate?.didFinishSettingUp(from: self)
    }
    override func finish() {
        
    }
}

extension PhilosopherCoordinator : PhilosopherCoordinatorViewModelDelegate{
    // MARK: Navigation (Philosopher View Model)
    
    func goToPhilosopherDetail(data: Philosopher, from vc : UIViewController) {
        let detailVc = PhilosopherDetailVc()
        detailViewModel.philosopherData = data
        detailVc.viewModel = detailViewModel
        detailVc.viewModel.viewDelegate = detailVc
        vc.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension PhilosopherCoordinator : PhilosopherDetailCoordinatorViewModelDelegate {
    // MARK: Philosopher detail view model coordinator implementation
    func goToPersonalThoughtsForAdding(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, from vc: UIViewController) {
        
        let personalThoughtsViewModel = PersonalThoughtViewModel(
            databaseService: databaseService, philosoperItem: philosoperData, ideaItem: ideaData
        )
        let personalThoughtVc = PersonalThoughtsVc()
        personalThoughtVc.viewModel = personalThoughtsViewModel
        personalThoughtVc.currentThoughtSnapshot = PersonalThoughtDataBaseModel(content: "")
        personalThoughtVc.editMode = false
        
        personalThoughtVc.thoughtsHeader.thoughtLabel.text = ideaData.idea
        let nav = UINavigationController(rootViewController: personalThoughtVc)
        vc.navigationController?.present(nav, animated: true)
    }
    
    func goToPersonalThoughtsForEditing(philosoperData: PhilosopherDataBaseModel, ideaData: IdeasDatabaseModel, thought: PersonalThoughtDataBaseModel, from vc: UIViewController) {
        let personalThoughtsViewModel = PersonalThoughtViewModel(
            databaseService: databaseService, philosoperItem: philosoperData, ideaItem: ideaData
        )
        // TODO: Pikirin caranya supaya ga setiap kali navigate bikin viewmodel baru
        let personalThoughtVc = PersonalThoughtsVc()
        personalThoughtVc.viewModel = personalThoughtsViewModel
        personalThoughtVc.editMode = true
        personalThoughtVc.currentThoughtSnapshot = PersonalThoughtDataBaseModel(content: thought.content)
        
        personalThoughtVc.thoughtsHeader.thoughtLabel.text = ideaData.idea
        personalThoughtVc.thoughtsTextField.text = thought.content
        let nav = UINavigationController(rootViewController: personalThoughtVc)
        vc.navigationController?.present(nav, animated: true)
    }
    
    func didFinish() {
        // TODO: When all are finished (ensure memory release)
    }
    
}


protocol PhilosopherAPIDelegate : AnyObject {
    //MARK: Delegate that handles output from back-end service
    func didFinishLoadingData(data : [Philosopher])
}

protocol AppCoordinatorDelegate : AnyObject {
    //MARK: Delegate that handles output from upper-layer coordinator
    func didFinishSettingUp(from coordinator : Coordinator)
}

protocol PhilosopherCoordinatorViewModelDelegate : AnyObject {
    //MARK: Delegate  that handles input from philosopher view model
    func goToPhilosopherDetail(data : Philosopher, from vc : UIViewController)
}

protocol PhilosopherDetailCoordinatorViewModelDelegate : AnyObject {
    // MARK: Delegate that handles input from philosopher detail view model
    func goToPersonalThoughtsForAdding(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, from vc : UIViewController)
    func goToPersonalThoughtsForEditing(philosoperData : PhilosopherDataBaseModel, ideaData : IdeasDatabaseModel, thought : PersonalThoughtDataBaseModel, from vc : UIViewController)
    
    func didFinish()
}
