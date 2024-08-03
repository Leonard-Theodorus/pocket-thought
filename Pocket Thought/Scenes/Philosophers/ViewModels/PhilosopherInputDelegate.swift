//
//  PhilosopherDetailDelegate.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import Foundation
import UIKit

protocol PhilosopherInputDelegate : AnyObject {
    var viewDelegate : PhilosopherViewModelViewDelegate? {get set}
    var showLoadingIndicator : Bool {get set}
    
    // MARK: -- Events --
    func start()
    func didSelectItem(index row : Int, from vc : UIViewController)
    
    // MARK: -- Data Source --
    func itemCount() -> Int
    func itemAt(row : Int) -> Philosopher
}
