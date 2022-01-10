//
//  SetGame.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import Foundation

struct SetGame {
    var cards: [Card]
    var cardsOnScreen: [Card] = [] 
    var discardedCards: [Card] = [] 
    var selectedCardsIndices: [Int] = []
    
    // Computed property for the selected cards indices
    var threeOnlySelectedCardsIndices: [Int] {
        get {cardsOnScreen.indices.filter{cardsOnScreen[$0].isSelected}}
        set {
            cardsOnScreen.indices.forEach {
                cardsOnScreen[$0].isSelected = newValue.contains($0)
                cardsOnScreen[$0].matchingStatus = .notChecked
            }
            discardedCards.indices.forEach({
                discardedCards[$0].isSelected = false
                discardedCards[$0].matchingStatus = .notChecked
            })
        }
    }
   
    struct Card: Equatable, Identifiable {
        var isSelected = false
        var matchingStatus: MatchedStatus = .notChecked
        var cardContent: Theme
        var id: Int
        
        // Cards will be comparable based on the Card Content.
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.cardContent == rhs.cardContent
        }
        enum MatchedStatus {
            case notChecked
            case checkedNotMatched
            case checkedMatched
        }
    }
    
    /// inisiate the Card Game by looping 81 times through the all shapes colors and shading.
    /// Which the number 81 is all the possible unique shapes you can get by the options in Theme.
    
    init(createCardContent: () -> Theme) {
        var cardsCount = 0
        cards = []
        while cardsCount < 81 {
            let cardContent = createCardContent()
            let card = Card(cardContent: cardContent, id: cards.count + 1 )
            if !cards.contains(card) {
                cards.append(card)
                cardsCount += 1
            }
        }
    }
    
    
    /// Choose the card you tap on and the action will be based on the number of items in the property "threeAndOnlyIndices"
    /// - Parameter card: of type Card which is the card you tap on.
    
    mutating func choose (_ card: Card) {
        guard let chosenIndex = cardsOnScreen.firstIndex(where: {$0.id == card.id}) else {return}
            
            // Switch between the number of items in the var " threeAndOnlyCardIndices"
            switch threeOnlySelectedCardsIndices.count {
            case 0:
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices = [chosenIndex]
            case 1:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
            case 2:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
                if matchingCards(
                    card1: cardsOnScreen[threeOnlySelectedCardsIndices[0]],
                    card2: cardsOnScreen[threeOnlySelectedCardsIndices[1]],
                    card3: cardsOnScreen[threeOnlySelectedCardsIndices[2]]
                )
                {threeOnlySelectedCardsIndices.forEach { cardsOnScreen[$0].matchingStatus = .checkedMatched}}
                else {threeOnlySelectedCardsIndices.forEach{cardsOnScreen[$0].matchingStatus = .checkedNotMatched}}
            case 3:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    guard !cardsAreMatched() else { return }
                    threeOnlySelectedCardsIndices = [chosenIndex]
                    return
                }
                if cardsAreMatched() {
                    
                    // saving the card id of the chosen index
                    // Becuase the chosen index will be changed after removing cards
                    let selectedCardId: Int = cardsOnScreen[chosenIndex].id
                    
                    // For loops are saving the inital arrays
                    // Thats why we have to update the index in each loop
                    // To get the correct updated index
                    threeOnlySelectedCardsIndices.forEach{ _ in
                        if let index = threeOnlySelectedCardsIndices.first {
                            discardedCards.append(cardsOnScreen.remove(at: index))
                        }
                    }
                    
                    // the chosen index now is the selected card id index
                    threeOnlySelectedCardsIndices = [cardsOnScreen.firstIndex(where:{ $0.id == selectedCardId})!]
      
                } else {
                    cardsOnScreen[chosenIndex].isSelected = true
                    threeOnlySelectedCardsIndices = [chosenIndex]
                }
            default:
                print("There is problem with selecting cards count > 3")
            }
    }
    
    /// Return the boolen value of which the three cards in the argument are matched or not
    func matchingCards(card1: Card, card2: Card, card3: Card) -> Bool {
        
            ((card1.cardContent.shape == card2.cardContent.shape &&
                card1.cardContent.shape == card3.cardContent.shape) ||
                (card1.cardContent.shape != card2.cardContent.shape &&
                    card1.cardContent.shape != card3.cardContent.shape &&
                    card2.cardContent.shape != card3.cardContent.shape))
                &&
                
                ((card1.cardContent.colorOfShape == card2.cardContent.colorOfShape &&
                    card1.cardContent.colorOfShape == card3.cardContent.colorOfShape) ||
                    (card1.cardContent.colorOfShape != card2.cardContent.colorOfShape &&
                        card1.cardContent.colorOfShape != card3.cardContent.colorOfShape &&
                        card2.cardContent.colorOfShape != card3.cardContent.colorOfShape))
                &&
                
                ((card1.cardContent.numberOfShapes == card2.cardContent.numberOfShapes &&
                    card1.cardContent.numberOfShapes == card3.cardContent.numberOfShapes) ||
                    (card1.cardContent.numberOfShapes != card2.cardContent.numberOfShapes &&
                        card1.cardContent.numberOfShapes != card3.cardContent.numberOfShapes &&
                        card2.cardContent.numberOfShapes != card3.cardContent.numberOfShapes))
                &&
                
                ((card1.cardContent.opacityOfShape == card2.cardContent.opacityOfShape &&
                    card1.cardContent.opacityOfShape == card3.cardContent.opacityOfShape) ||
                    (card1.cardContent.opacityOfShape != card2.cardContent.opacityOfShape &&
                        card1.cardContent.opacityOfShape != card3.cardContent.opacityOfShape &&
                        card2.cardContent.opacityOfShape != card3.cardContent.opacityOfShape))
        ? true : false
    }
    
    /// Return the boolen value if there are three matched cards.
    func cardsAreMatched() -> Bool {
        return cardsOnScreen.indices.filter({cardsOnScreen[$0].matchingStatus == .checkedMatched}).count >= 3
    }
    
    /// Deal the first 12 cards at the beginning of the game.
    mutating func dealTheFirstCards() {
        while cardsOnScreen.count < 12 {
            cardsOnScreen.append(cards.removeFirst())
        }
    }
    
    /// Deal three cards when you tap the deck.
    ///
    /// if there are already matched cards, it will  replace it with new three cards.
    /// otherwise, add three cards to the collection of "cardsOnScreen".
    ///
    /// If ti's new game, start the game by dealing 12 cards if cardsOnScreen is equal to zero.
    mutating func dealCards() {
        if cardsOnScreen.count < 12 {
            dealTheFirstCards()

        } else {
            if cardsAreMatched() {
                threeOnlySelectedCardsIndices.forEach{
                    discardedCards.append(cardsOnScreen[$0])
                    cardsOnScreen[$0] = cards.removeFirst()
                }
                threeOnlySelectedCardsIndices = []
            } else {
                cardsOnScreen.add(3, from: &cards)
            }
        }
    }
    /// Remove the matched cards from the Body of the game to the Discarded cards deck
    mutating func discardCards() {
        if cardsAreMatched() {
            threeOnlySelectedCardsIndices.forEach({
                discardedCards.append(cardsOnScreen[$0])
            })
        }
    }
}


