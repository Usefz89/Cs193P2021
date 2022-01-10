//
//  MemoryGame.swift
//  Assignment one
//
//  Created by yousef zuriqi on 27/09/2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private var indexOfOneAndOnlyFaceUpCard: Int?
    private(set) var scoreCounter = 0
    private var facedUpCards: [Card] = []
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        
        self.cards = []
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
     mutating func choose(_ card: Card) {
        
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !card.isFaceUp,
           !card.isMatched
           {
            if let possibleMatch = indexOfOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[possibleMatch].content {
                    scoreCounter += 2
                    cards[chosenIndex].isMatched = true
                    cards[possibleMatch].isMatched = true
                    
                } else {
                    if facedUpCards.contains(where: { card in
                        return card.id == cards[chosenIndex].id
                    }) {
                        scoreCounter -= 1
                    }
                    if facedUpCards.contains(where: { card in
                        card.id == cards[possibleMatch].id
                    }) {
                        scoreCounter -= 1
                    }
                    
                    facedUpCards.append(cards[possibleMatch])
                    facedUpCards.append(cards[chosenIndex])
                    
                }
                indexOfOneAndOnlyFaceUpCard = nil
                
                
                
            } else  {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
     struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
    
    
    
}
