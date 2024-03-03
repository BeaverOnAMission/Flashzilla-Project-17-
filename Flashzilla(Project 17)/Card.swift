//
//  Card.swift
//  Flashzilla(Project 17)
//
//  Created by mac on 16.09.2023.
//

import Foundation

struct Card: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Wittaker")
}
