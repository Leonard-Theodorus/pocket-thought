//
//  IdeasDatabaseModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation
import CryptoKit

struct IdeasDatabaseModel : Codable {
    let id : String
    let idea : String
    
    init(idea: String) {
        let data = Data(idea.utf8)
        let hash = SHA256.hash(data: data)
        self.id = hash.map {String(format: "%02x", $0)}.joined()
        self.idea = idea
    }
}
