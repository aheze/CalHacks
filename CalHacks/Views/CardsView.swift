//
//  CardsView.swift
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
    
    static let placeholderCard = Card(
        id: "Card1",
        title: "Placeholder Card",
        description: "Very epic card for CalHacks!!!",
        backgroundColor: "00e600",
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

struct CardsView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            Text("Cards")
                .font(.largeTitle)
            
            ScrollView {
                LazyVStack {
                    ForEach(model.cards) { card in
                        CardView(card: card)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 32)
    }
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        let color = UIColor(hexString: card.backgroundColor) ?? .systemRed
        
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.color, lineWidth: 10)
                        .brightness(0.2)
                }
                .padding(.bottom, -32)
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text(card.title)
                    .font(.title)
                
                Text(card.description)
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .background {
                color.color
                    .brightness(-0.1)
                    .mask {
                        SlantShape(tlOffset: 32)
                    }
                    .shadow(color: .white.opacity(0.2), radius: 24, x: 0, y: 0)
                    .padding(.top, -32)
            }
        }
        .background {
            color.color
        }
        .mask {
            RoundedRectangle(cornerRadius: 16)
        }
    }
}
