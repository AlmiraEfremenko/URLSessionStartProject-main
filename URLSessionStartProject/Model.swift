//
//  Model.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29/11/21.
//

import Foundation
import FileProvider

struct Cards: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let name: String?
    let artist: String?
    let manaCost: String?
    let setName: String?
    let type: String?
}
