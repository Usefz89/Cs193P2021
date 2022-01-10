//
//  ContentView.swift
//  Assignment one
//
//  Created by yousef zuriqi on 25/09/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
            VStack {
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    if card.isMatched && !card.isFaceUp {
                        Color.clear
                    } else {
                        CardView(card: card, color: game.theme.actualColor)
                            .padding(10)
                            .onTapGesture {
                                withAnimation {
                                    game.choose(card)
                                }
                        }
                    }
                }
                Text("Game Score = \(game.scoreCounter)")
                    .font(.headline)
            }
            .padding(.horizontal)
            .navigationTitle("\(game.theme.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    newGameButton
                }
            }
            
    }
    var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                game.startNewGame()
            }
        }
    }
}

//MARK: - CARDVIEW

struct CardView: View  {
    var card: MemoryGame<String>.Card
    var color: Color
     
    var body: some View {
        Text(card.content)
            .cardify(isFaceUp: card.isFaceUp)
            .foregroundColor(color)
    }
}


//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemesStore().themes[0])
        EmojiMemoryGameView(game: game)
            .environmentObject(ThemesStore())
    }
}
