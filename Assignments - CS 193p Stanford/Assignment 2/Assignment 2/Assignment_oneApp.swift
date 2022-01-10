//
//  Assignment_oneApp.swift
//  Assignment one
//
//  Created by yousef zuriqi on 25/09/2021.
//

import SwiftUI

@main
struct Assignment_oneApp: App {
    var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
