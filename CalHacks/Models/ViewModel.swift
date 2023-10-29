//
//  ViewModel.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

enum Tab {
    case cards
    case battle
    case config
}

class ViewModel: ObservableObject {
    @Published var entered = false
    @Published var selectedTab = Tab.cards
    @Published var cards = [Card.placeholderCard1, Card.placeholderCard2]
    @Published var cardsStore = [Card.placeholderCard1, Card.placeholderCard2]
}
