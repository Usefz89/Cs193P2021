//
//  ThemeChooserView.swift
//  Assignment Two
//
//  Created by yousef zuriqi on 01/11/2021.
//

import SwiftUI

struct ThemeChooserView: View {
    
    @EnvironmentObject var themeStore: ThemesStore
    @State private var editMode: EditMode = .inactive
    @State private var editorToShow: Bool = false
    @State private var itemToPresent: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(
                        destination: EmojiMemoryGameView(
                            game: EmojiMemoryGame(theme: theme)
                        )
                    ) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .font(.system(.title).bold())
                                .foregroundColor(Color(rgbaColor: theme.color))
                                .padding(.bottom, 2)
                            Text("Number of Cards = \(theme.numberOfPairsOfCards * 2)")
                                .font(.headline)
                            Text("All of: " + theme.emojis.withNoRepeatedCharacters)
                                .font(.headline)
                                .lineLimit(1)
                        }
                    }
                    // This is the solution for editing the selected row.
                    // Check later why the isPresetned init is not doing very well. 
                    .sheet(item: $itemToPresent, content: { item in
                        if let index = themeStore.themes.index(matching: item) {
                            ThemeEditor(theme: $themeStore.themes[index])
                        }
                    })
//                   .sheet(isPresented: $editorToShow {
//                        if let index = themeStore.themes.index(matching: theme) {
//                            ThemeEditor(theme: $themeStore.themes[index])
//                        }
//                    }
                    
                    .gesture(editMode.isEditing ? tap(theme: theme) : nil)
                   
                }
                .onDelete(perform: removeTheme)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    addThemeButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("Memorize")
            
            EmojiMemoryGameView(game: EmojiMemoryGame(theme: themeStore.themes[0]))

            

        }
//        .navigationViewStyle(.stack)
    }
   
    
    //MARK: - Add New Theme

    var addThemeButton: some View {
        Button {
            appendTheme()
            itemToPresent = themeStore.themes.last!
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func appendTheme() {
        themeStore.themes.append(
            Theme(name: "", numberOfPairsOfCards: 2, emojis: "😀😆😎🥸", color: .black)
        )
    }
    
    //MARK: - Remove Themes:
    
    private func removeTheme(at offSet: IndexSet) {
        themeStore.themes.remove(atOffsets: offSet)
    }
    
    //MARK: - Gestures
    
    private func tap(theme: Theme ) -> some Gesture {
        TapGesture()
            .onEnded { _ in
                itemToPresent = theme
            }
    }
}














//MARK: - Preview

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView()
            .environmentObject(ThemesStore())
    }
}
