//
//  Card.swift
//  Flashzilla
//
//  Created by Sree on 16/01/22.
//

import Foundation


struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played is who", answer: "Someone")
}
