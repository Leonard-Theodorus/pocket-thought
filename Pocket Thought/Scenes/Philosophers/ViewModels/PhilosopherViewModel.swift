//
//  PhilosopherViewModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 05/07/24.
//

import Foundation
import UIKit

final class PhilosopherViewModel {
    //MARK: -- Services --
    let apiService : PhilosopherAPIService
    
    //MARK: -- Delegates --
    var viewDelegate : PhilosopherViewModelViewDelegate?
    var coordinatorDelegate : PhilosopherCoordinatorViewModelDelegate?
    
    var philosophers : [Philosopher] = []
    
    var showLoadingIndicator: Bool = true
    
    init(apiService: PhilosopherAPIService!) {
        self.apiService = apiService
    }
    
}

extension PhilosopherViewModel : PhilosopherAPIDelegate {
    // MARK: Delegate that handles backend output to be displayed to view
    
    func didFinishLoadingData(data: [Philosopher]) {
        philosophers = data
        showLoadingIndicator = false
        viewDelegate?.didFinishLoading(philosophers: data)
    }
}

extension PhilosopherViewModel : PhilosopherInputDelegate {
    
    // MARK: Delegate that handles view inputs
    func start(){
        Task {
            await apiService.getPhilosopherData(queryName: "")
        }
    }
    
    func didSelectItem(index row : Int, from vc : UIViewController) {
        let itemAtRow = philosophers[row]
        coordinatorDelegate?.goToPhilosopherDetail(data: itemAtRow, from: vc)
    }
    
    func itemCount() -> Int {
        philosophers.count
    }
    
    func itemAt(row: Int) -> Philosopher {
        philosophers[row]
    }
    
}
