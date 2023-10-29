//
//  Card.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct Card: Identifiable {
    var id: String
    var title: String
    var description: String
    var backgroundColor: String
    var move1: Move
    var move2: Move
//    var previewImage:
    
    static let placeholderCard1 = Card(
        id: "Card1",
        title: "Placeholder Card",
        description: "Very epic card for CalHacks!!!",
        backgroundColor: "00e600",
        move1: Move.placeholderMove1,
        move2: Move.placeholderMove2
    )
    
    static let placeholderCard2 = Card(
        id: "Card2",
        title: "Blue Card",
        description: "This card is blue!",
        backgroundColor: "0089ff",
        move1: Move.placeholderMove1,
        move2: Move.placeholderMove2
    )
}

struct Move: Identifiable {
    var id: String
    var title: String
    var description: String
    var damage: Double
    
    static let placeholderMove1 = Move(
        id: "1",
        title: "Placeholder Move",
        description: "A placeholder move. This move does 5 amount of damage.",
        damage: 5
    )
    
    static let placeholderMove2 = Move(
        id: "2",
        title: "Very Cool Move",
        description: "This move is super cool. This move does 15 damage.",
        damage: 15
    )
}
