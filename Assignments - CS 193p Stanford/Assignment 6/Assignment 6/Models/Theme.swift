//
//  Theme.swift
//  Assignment one
//
//  Created by yousef zuriqi on 27/09/2021.
//

import Foundation



struct Theme: Identifiable, Hashable, Codable {
    var name: String
    var emojis: String
    var numberOfPairsOfCards: Int
    var color: RGBAColor
    var id = UUID()
    
  
    
    init(name: String, emojis: String, numberOfPairsOfCards: Int, rgbaColor: RGBAColor) {
        var computedNumberOfPairs: Int {
            numberOfPairsOfCards > emojis.count ? emojis.count : numberOfPairsOfCards
        }
        self.name = name
        self.emojis = emojis.withNoRepeatedCharacters
        self.numberOfPairsOfCards = computedNumberOfPairs
        self.color = rgbaColor
    }

}

struct RGBAColor: Codable, Equatable, Hashable {
 let red: Double
 let green: Double
 let blue: Double
 let alpha: Double
    
}

