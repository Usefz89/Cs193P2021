//
//  EmojiMemoryGame.swift
//  Assignment one
//
//  Created by yousef zuriqi on 27/09/2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    
    @Published private var model: MemoryGame<String>
    var theme: Theme = ThemesStore().themes[0]
   
    init(theme: Theme) {
        self.theme = theme 
        model = Self.makeMemoryGame(theme: theme)
    }
    
     var cards: [MemoryGame<String>.Card] {
         model.cards
    }
    
    var scoreCounter: Int {
        model.scoreCounter
    }
    
    //MARK: - FUNCTIONS:
    
     static func makeMemoryGame(theme: Theme) -> MemoryGame<String> {
         // If emojis has been removed change the number of pairs to emoji.count
        
         
    return MemoryGame(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            theme.emojis.withNoRepeatedCharacters.map{String($0)}[pairIndex]
        }
        
    }
    
    // MARK: - INTENTS:
    
     func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = Self.makeMemoryGame(theme: theme)
        
    }
}

