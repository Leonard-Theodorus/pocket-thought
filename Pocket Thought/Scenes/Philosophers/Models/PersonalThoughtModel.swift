//
//  PersonalThoughtModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 23/07/24.
//

import Foundation

struct PersonalThoughtModel : Codable{
    let id : String
    let content : String
    
    init(from dto : PersonalThoughtDataBaseModel) {
        self.id = dto.id
        self.content = dto.content
    }
}
