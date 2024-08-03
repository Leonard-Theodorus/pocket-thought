//
//  UserAuthModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 16/07/24.
//

import Foundation
import FirebaseAuth

struct UserAuthModel {
    let uid : String
    let email : String?
    let displayName : String?
    
    init(from user : User){
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
    }
}
