//
//  Philosopher.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 05/07/24.
//

import Foundation
import UIKit

struct Philosopher {
    
    let id : Int
    let books : [String]
    let bornDate : String
    let deathDate : String
    let name : String
    let nationality : String
    var ideas : [Idea]
    var photo : UIImage
    let school : [String]
    
    init(from dto: PhilosopherDTO){
        self.id = dto.id
        self.books = dto.books
        self.bornDate = dto.bornDate
        self.deathDate = dto.deathDate
        self.name = dto.name
        self.nationality = dto.nationality
        self.ideas = []
        for idea in dto.ideas {
            self.ideas.append(Idea(idea: idea, personalThoughts: []))
        }
        self.photo = UIImage()
        self.school = dto.school
    }
}
