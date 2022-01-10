//
//  Set_Assignment3App.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

@main
struct Assignment4App: App {
    var game = SetGameMode()
   
    var body: some Scene {
        
        WindowGroup {
            SetGameView(game: game)
            
        }
    }
}
