//
//  DataBaseThoughtInputModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation

struct DataBaseThoughtInputModel : Codable {
    let user : UserDatabaseModel
    let philosopher : PhilosopherDataBaseModel
    let idea : IdeasDatabaseModel
    let thought : PersonalThoughtDataBaseModel
    
}
