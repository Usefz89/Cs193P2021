//
//  ThemeEditor.swift
//  Assignment Two
//
//  Created by yousef zuriqi on 02/11/2021.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    var body: some View {
        Form {
            nameSection
            emojiSection
            addEmojiSection
            cardCountSection
            colorSection
        }
    }
    // Name section
    private var nameSection: some View {
        Section(header: Text("Theme Name").font(.headline)) {
            TextField("Theme Name", text: $theme.name)
        }
    }
    
    //MARK: -  Add Emoji Section
    private var emojiSection: some View {
        Section(header: emojiHeader) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.withNoRepeatedCharacters.map {String($0).filter {$0.isEmoji}}, id: \.self) { emoji in
                    Text(emoji).font(Font.system(size: 40))
                        .onTapGesture {
                            // Delete tapped emoji.
                            remove(emoji: emoji)
                        }
                }
            }
        }
    }
    
    private func remove(emoji: String)  {
        if Character(emoji).isEmoji, theme.numberOfPairsOfCards >= 3 {
            if theme.emojis.count > theme.numberOfPairsOfCards {
                theme.emojis.removeAll(where: {$0 == Character(emoji)})
            } else {
                theme.numberOfPairsOfCards -= 1
                theme.emojis.removeAll(where: {$0 == Character(emoji)})
            }
        }
    }
    
    private var emojiHeader: some View {
        HStack {
            Text("Emoji").font(.headline)
            Spacer()
            Text("TAP EMOJI TO EXCLUDE").font(.caption)
        }
    }
//MARK: - Add Emoji Section
    
    @State private var addedEmoji = ""
    var addEmojiSection: some View {
        Section(header: Text("ADD EMOJI")) {
            TextField("Add Emoji", text: $addedEmoji)
                .onChange(of: addedEmoji) { newValue in
                    for ch in newValue.withNoRepeatedCharacters {
                        if ch.isEmoji {
                            theme.emojis = theme.emojis + String(ch)
                        }
                    }
                }
        }
    }
//MARK: - Increase Number Of Pairs
    
    var cardCountSection: some View {
        Section(header: Text("Card Count")) {
            Stepper("\(theme.numberOfPairsOfCards) Pairs") {
                if theme.emojis.count > theme.numberOfPairsOfCards {
                    theme.numberOfPairsOfCards += 1
                }
            } onDecrement: {
                if theme.numberOfPairsOfCards > 2 {
                    theme.numberOfPairsOfCards -= 1

                }
            }
        }
    }
    
//MARK: - Color Selection Section
    
    var uiColorName: String {
        let name = UIColor(theme.actualColor).accessibilityName
        return name.capitalized
    }
    
    var colorSection: some View {
        Section(header: Text("Pick a Color")) {
            ColorPicker("\(uiColorName)", selection: $theme.actualColor, supportsOpacity: false)
                
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemesStore().themes[0]))
    }
}
