//
//  Theme.color.swift
//  Assignment Two
//
//  Created by yousef zuriqi on 02/11/2021.
//

import SwiftUI

extension Theme {
    var actualColor: Color {
        get {
            Color(rgbaColor: self.color)
        }
        set {
            self.color = RGBAColor(color: newValue)
        }
    }
    
    /// Initiate Theme from actual Color struct
    ///
    init(name: String, numberOfPairsOfCards: Int, emojis: String, color: Color) {
        var computedNumberOfPairs: Int {
            return numberOfPairsOfCards > emojis.count ? emojis.count : numberOfPairsOfCards
        }
        self.name = name
        self.numberOfPairsOfCards = computedNumberOfPairs
        self.emojis = emojis
        self.color = RGBAColor(color: color)
        self.actualColor = color 
        
    }
}
