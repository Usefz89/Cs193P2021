//
//  Assignment_oneApp.swift
//  Assignment one
//
//  Created by yousef zuriqi on 25/09/2021.
//

import SwiftUI

@main
struct Memorize: App {
    @StateObject var themeStore = ThemesStore()
    var body: some Scene {
        WindowGroup {
            ThemeChooserView()
                .environmentObject(themeStore)
        }
    }
}
