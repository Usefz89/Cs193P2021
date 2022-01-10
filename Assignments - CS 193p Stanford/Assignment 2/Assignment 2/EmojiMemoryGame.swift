//
//  EmojiMemoryGame.swift
//  Assignment one
//
//  Created by yousef zuriqi on 27/09/2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    
    @Published private var model: MemoryGame<String>
    private var theme: Theme
    var themeName: String {
        theme.name
    }
     
    private static var themes: [Theme] =
        [
            Theme(name: "Vehicle Emojis", emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🛻", "🚚", "🚛", "🚜", "✈️", "🛵", "🏍", "🚀"], numberOfPairsOfCards: 8, color: "blue"),
            Theme(name: "Sports Emojis", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🏓", "🏸"], numberOfPairsOfCards: 6, color: "red"),
            Theme(name: "Foods Emojis", emojis: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍔", "🍟", "🍕"], numberOfPairsOfCards: 5, color: "green"),
            Theme(name: "Object Emojis", emojis: ["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "🖱", "🕹", "💽", "💾", "📷", "📞", "☎️", "📟", "🎙", "⏰", "💡"], numberOfPairsOfCards: 8, color: "orange"),
            Theme(name: "Flags Emojis", emojis: ["🏳️","🏴","🏴‍☠️","🏁","🚩","🏳️‍🌈","🇺🇳","🇦🇫","🇦🇽","🇦🇱","🇩🇿","🇦🇸","🇦🇩","🇦🇴","🇦🇮","🇦🇺","🇦🇹","🇧🇪","🇧🇯","🇨🇦","🇮🇨","🇨🇻","🇧🇶","🇫🇷","🇵🇫","🇮🇶","🇮🇱","🇮🇹","🇯🇴",], numberOfPairsOfCards: 8, color: "black"),
            Theme(name: "", emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🐮","🐷","🐸","🐵","🐔"], numberOfPairsOfCards: 8, color: "yellow")
        ]
    
    init() {
        theme = Self.themes.randomElement()!
        theme.emojis.shuffle()
        model = Self.makeMemoryGame(theme: theme)
    }
    
    
     var cards: [MemoryGame<String>.Card] {
         model.cards
        
    }
    
    var scoreCounter: Int {
        model.scoreCounter
    }
    
     var color: Color {
        switch theme.color {
        case "red": return Color.red
        case "blue": return Color.blue
        case "green": return Color.green
        case "orange": return Color.orange
        case "black": return Color.black
        case "yellow": return Color.yellow
        default: return Color.red
        }
    }
    
    //MARK: - FUNCTIONS:
    
    private static func chooseTheme() -> Theme {
        Self.themes[Int.random(in: 0 ..< EmojiMemoryGame.themes.count)]
    }
    
     static func makeMemoryGame(theme: Theme) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            theme.emojis[pairIndex]
        }
        
    }
    
    // MARK: - INTENTS:
    
     func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        theme = Self.themes.randomElement()!
        theme.emojis.shuffle()
        model = Self.makeMemoryGame(theme: theme)
            
    }
    
    
}













//    static var vehicleEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑"]
//    static var sportEmojis = ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🏓", "🏸"]
//    static var foodEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍔", "🍟", "🍕"]
