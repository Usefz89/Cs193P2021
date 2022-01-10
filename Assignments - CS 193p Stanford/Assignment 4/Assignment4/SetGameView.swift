//
//  SetGameView.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGameMode
    @State private var dealt = Set<Int>()
    @State private var isFaceUp = false
    @Namespace private var discardedNameSpace
    @Namespace private var dealcardsNameSpace
  
    
    //MARK:- MAIN
    var body: some View {
        ZStack {
            Image("green")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                gameBody
                    
                HStack {
                    discardedCardsBody
                    Spacer()
                    deckBody
                }
                .padding()
                newGameButton
            }
        }
    }
    
//MARK:- GAME BODY
    var gameBody: some View {
        
        AspectVGrid(items: game.cardsOnScreen, aspectRatio: Constants.aspectRatio) { card  in
                if notDealt(card)  {
                    Color.clear
                } else {
                    CardView(card: card)
                    .padding(5)
                    .foregroundColor( game.colorOfShape(card: card))
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: discardedNameSpace)
                    .matchedGeometryEffect(id: card.id, in: dealcardsNameSpace)
                    .onTapGesture {
                        withAnimation {
                            game.choose(card: card)
                        }
                    }
                }
            }
        .padding()
        .onAppear{
            game.dealTheFirstCards()
            for card in game.cardsOnScreen {
                withAnimation(dealAnimation(card: card)) {
                    deal(card)
                }
            }
        }
    }
    
//MARK:- DECK BODY
    var deckBody: some View {
        ZStack {
            ForEach(game.cards) { card in
                let index = game.cards.firstIndex(where: {$0.id == card.id})!
                Group {
                    if isFaceUp {
                        CardView(card: card)
                            .zIndex(zIndex(of: card))
                    } else {
                        RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(Color.yellow)
                        RoundedRectangle(cornerRadius: Constants.cornerRadius).strokeBorder(Color.black, lineWidth: 3)
                    }
                }
                .offset(x: (CGFloat(index) * 0.1), y: (CGFloat(index) * 0.1))
                .matchedGeometryEffect(id: card.id, in: dealcardsNameSpace)
            }
        }
        .frame(width: Constants.deckWidth , height: Constants.deckHeight)
        .onTapGesture {
            if game.cardsOnScreen.count < 12 {
                game.dealTheFirstCards()
                for card in game.cardsOnScreen {
                    withAnimation(dealAnimation(card: card)) {
                        deal(card)
                    }
                }
               
            } else {
                game.dealCards()
                for card in game.cardsOnScreen {
                    withAnimation() {
                        deal(card)

                    }
                }
            }
        }
    }
    
//MARK:- DISCARDED CARD BODY
    var discardedCardsBody: some View {
        
        ZStack {
            
            ForEach(game.discardedCards) { card in
                    CardView(card: card)
                        .foregroundColor(game.colorOfShape(card: card))
                        .transition(.asymmetric(insertion: .identity, removal: .scale))
                        .matchedGeometryEffect(id: card.id, in: discardedNameSpace)
               
               
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckHeight)
    }
    
    // Buttons area
    var newGameButton: some View {
        Button(action: {
            withAnimation {
                game.newGame()
                dealt = []
            }
        }) {
            Text("NEW GAME")
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
    //MARK:- FUNCTIONS
    
    private func dealAnimation(card: SetGame.Card) -> Animation {
        let index = game.cardsOnScreen.firstIndex(where: {$0.id == card.id}) ?? 0
        let delay = ((Constants.dealTotalDuration / Double(game.cardsOnScreen.count)) * Double(index))
            + Constants.startdelayDuration
        return Animation.easeOut(duration: Constants.dealDuration).delay(Double(delay))
    }
    private func deal3CardsAnimation(card: SetGame.Card) -> Animation {
        let droppedCardsCount = game.cardsOnScreen.count
        let cardsSlice = game.cardsOnScreen.dropFirst(droppedCardsCount - 3)
        let newArray = Array(cardsSlice)
        let index = newArray.firstIndex(where: {$0.id == card.id}) ?? 0
        let delay = (Constants.deal3CardsTotalDuration / 3) * Double(index)
        return Animation.easeOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SetGame.Card) -> Double {
        return -Double((game.cards.firstIndex(where: {card.id == $0.id})) ?? 0)
    }
    
     private func deal(_ card: SetGame.Card) {
        dealt.insert(card.id)
    }
  
    private func notDealt( _ card: SetGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
   
    
    // MARK:- CONSTANTS STRUCT
    
    struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let deckHeight: CGFloat = 90
        static let deckWidth: CGFloat = deckHeight * aspectRatio
        static var cornerRadius: CGFloat = CardView.Constants.cornerRadius
        static let dealTotalDuration: Double = 1
        static let deal3CardsTotalDuration: Double = 0.5
        static let dealDuration: Double = 0.5
        static let startdelayDuration: Double = 0.3

    }
}

//MARK: - PREVIEW AREA

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameMode()
        SetGameView(game: game)
    }
    private func delay(card: SetGame.Card) -> Double {
        
        
        return 1
    }
}


