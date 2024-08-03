//
//  UserDatabaseModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation
import FirebaseAuth

struct UserDatabaseModel : Codable {
    let uid : String
    let email : String
    
    init(from user : User){
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}
