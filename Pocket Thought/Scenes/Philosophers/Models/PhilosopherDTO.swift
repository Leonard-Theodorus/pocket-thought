//
//  Philosopher.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 05/07/24.
//

import Foundation

struct PhilosopherDTO : Decodable {
    let id : Int
    let books : [String]
    let bornDate : String
    let deathDate : String
    let name : String
    let nationality : String
    let ideas : [String]
    let photoURLString : String
    let school : [String]
    
    enum CodingKeys : String, CodingKey{
        case id
        case books
        case ideas
        case school
        case name
        case photoURLString = "photo"
        case bornDate = "born_date"
        case deathDate = "death_date"
        case nationality
    }
}
