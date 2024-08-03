//
//  Coordinator.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 04/07/24.
//

import Foundation

class Coordinator {
    private(set) var childCoordinators : [Coordinator] = []
    
    func start(){
        //MARK: To-be-overriden by implementing child classes
    }
    
    func finish(){
        //MARK: To-be-overriden by implementing child classes
    }
    
    func addChildCoordinators(_ coordinator : Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator : Coordinator){
        if let index = childCoordinators.firstIndex(of: coordinator){
            childCoordinators.remove(at: index)
        }
        else{
            print("No coordinator : \(coordinator) exists")
        }
    }
    
    func removeAllChildCoordinators(){
        childCoordinators.removeAll()
    }
}

extension Coordinator : Equatable{
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        lhs === rhs
    }
}
