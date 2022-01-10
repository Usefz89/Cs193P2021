//
//  ContentView.swift
//  Assignment one
//
//  Created by yousef zuriqi on 25/09/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
   
    var body: some View {
        NavigationView {
            VStack {
                ScrollView  {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                        ForEach(viewModel.cards) { card  in
                            CardView(card: card, color: viewModel.color)
                                .aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture {
                                    viewModel.choose(card)
                            }
                        }
                    }
                }
                Text("Game Score = \(viewModel.scoreCounter)")
                    .font(.headline)
                Button(action: {viewModel.startNewGame()}, label: {
                    newGameButton
                })
            }
            .navigationTitle("\(viewModel.themeName)")
        }
        .padding(.horizontal)
    }
    var newGameButton: some View {
        Text("NEW GAME")
            .font(.title3).bold()
            .padding()
            .background(Color.orange)
            .cornerRadius(15)
            .shadow(radius: 5)
            .foregroundColor(.white)
    }
}

struct CardView: View  {
    var card: MemoryGame<String>.Card
    var color: Color
     
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
                
            } else {
                shape.fill()
            }
        }
        .foregroundColor(color)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
}
