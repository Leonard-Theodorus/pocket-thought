//
//  PhilosopherDataBaseModel.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 22/07/24.
//

import Foundation
import CryptoKit

struct PhilosopherDataBaseModel : Codable{
    let id : String
    let name : String
    
    init(name: String) {
        let data = Data(name.utf8)
        let hash = SHA256.hash(data: data)
        self.id = hash.map {String(format: "%02x", $0)}.joined()
        self.name = name
    }
}
