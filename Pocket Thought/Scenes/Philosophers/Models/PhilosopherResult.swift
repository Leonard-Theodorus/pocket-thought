//
//  PhilosopherResult.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 06/07/24.
//

import Foundation

struct PhilosopherResult : Decodable {
    let results : [PhilosopherDTO]
    
    enum CodingKeys: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([PhilosopherDTO].self, forKey: .results)
    }
}
