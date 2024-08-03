//
//  ViewModel + View.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 06/07/24.
//

import Foundation

protocol PhilosopherViewModelViewDelegate : AnyObject {
    func didFinishLoading(philosophers : [Philosopher])
    
}
