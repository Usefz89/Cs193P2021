//
//  CardView.swift
//  Assignment4
//
//  Created by yousef zuriqi on 11/10/2021.
//

import SwiftUI

struct CardView: View {
   
    let card: SetGame.Card
   
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill()
                    .foregroundColor(.white)
                    
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(lineWidth: card.isSelected ? Constants.selectedLineWidth : 1 )
//                    .animation(.easeInOut(duration: 0.1))
                    .foregroundColor(getBorderColor(of: card))
                    .shadow(color: .clear, radius: 3)
                    

                getCardContent(in: geometry.size, from: card)
                    .rotationEffect(Angle.degrees(card.matchingStatus == .checkedMatched ? 360 : 0))
                    .scaleEffect(card.matchingStatus == .checkedNotMatched ? 1.2 : 1 )
            }
            
        }
        
    }

    func getBorderColor(of card: SetGame.Card) -> Color {
        switch card.matchingStatus {
        case .notChecked: return Color.yellow
        case .checkedNotMatched: return Color.red
        case .checkedMatched: return Color.green
            
        }
    }
 
    /// Returns Card Content View that matches the Shape enum and number of Shape enums in the CardGame struct
    /// - Parameter size: The container size
    /// - Parameter card: CardView instance

    
    @ViewBuilder
    func getCardContent(in size: CGSize, from card: SetGame.Card) -> some View {
        VStack {
            ForEach(0..<card.cardContent.numberOfShapes.rawValue, id: \.self) { _ in
                switch card.cardContent.shape {
                case .oval :
                    ZStack {
                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)

                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                case .rectangle:
                    ZStack {
                        Rectangle()
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)
                            
                        Rectangle()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                case .diamond:
                    ZStack {
                        Diamond()
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)
                         
                        Diamond()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                }
            }
        }
    }
   
    struct Constants {
        static var cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let selectedLineWidth: CGFloat = 5
        static let notSelectedLineWidth: CGFloat = 1

    }
}

struct CardView_Previews: PreviewProvider {
    static let game = SetGameMode()
    static var card: SetGame.Card {
        game.cards.first!
    }
    
    static var previews: some View {
        CardView(card: card)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding(.all)
            
    }
}
