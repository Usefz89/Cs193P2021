//
//  SetGameMode.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

class SetGameMode: ObservableObject  {
    typealias Card = SetGame.Card
    
    private static var  themes: [Theme] = makeThemes()
    
    
    static func makeThemes() -> [Theme] {
        var themesCount = 0
        var themes: [Theme] = []
        while themesCount < 81 {
            let theme = Theme(
                shape: Theme.Shape.allCases.randomElement()!,
                numberOfShapes: Theme.NumberOfShapes.allCases.randomElement()!,
                colorOfShape: Theme.ColorOfShape.allCases.randomElement()!,
                opacityOfShape: Theme.OpacityOptions.allCases.randomElement()!
            )
            if !themes.contains(theme) {
                themes.append(theme)
                themesCount += 1
            }
        }
        return themes
    }
    
    static func makeModel() -> SetGame {
        return SetGame { themes.randomElement()! }
    }
    
    @Published private var model: SetGame = makeModel()
    
    var cards: [Card] {
        model.cards
    }
    var cardsOnScreen: [Card] {
        model.cardsOnScreen
    }
    var discardedCards: [Card] {
        model.discardedCards
    }
    
    func colorOfShape(card: SetGame.Card) -> Color {
        let colorString: Theme.ColorOfShape = card.cardContent.colorOfShape
        switch colorString {
        
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        case .green:
            return Color.green
        }
    }
    
    func cardsAreMatched() -> Bool {
        model.cardsAreMatched()
    }
   
    
    //MARK: - INTENT:
    func choose( card: SetGame.Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    func dealTheFirstCards() {
        model.dealTheFirstCards()
    }
    
    func discardCards() {
        model.discardCards()
    }
    
    func newGame() {
        model = Self.makeModel()
    }
   
    
}


  


    

