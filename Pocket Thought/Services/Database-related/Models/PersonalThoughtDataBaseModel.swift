//
//  ThoughtDataBaseModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation
import CryptoKit

struct PersonalThoughtDataBaseModel : Codable{
    let id : String
    let content : String
    
    init(content: String) {
        let hash = SHA256.hash(data: Data(content.utf8))
        self.id = hash.map {String(format: "%02x", $0)}.joined()
        self.content = content
    }
}
