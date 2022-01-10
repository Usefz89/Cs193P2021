//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size).exclusively(before: singleTapOnBackground()))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        VStack {
                            HStack {
                                DeleteButton(document: document, emoji: emoji)
                                Spacer()
                            }
                            .frame(width: 100)
                                .opacity(isLongPressed(emoji) ? 1 : 0)
                            Text(emoji.text)
                                .background(selectionCircle(emoji: emoji))
                        }
                        
                        .font(.system(size: fontSize(for: emoji)))
                        .scaleEffect(isSelected(emoji) ? gestureEmojiZoomScale * zoomScale : zoomScale)
                        .position(position(for: emoji, in: geometry))
                        .offset(isSelected(emoji) ? gestureStateDragEmojiOffset : .zero)
                        .gesture(selectGesture(emoji).simultaneously(with: panGesture(emoji: emoji)).exclusively(before: longPressGesture(emoji)))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
        }
    }
    
    //MARK: - Delete Button
    
    struct DeleteButton: View {
        @ObservedObject var document: EmojiArtDocument
        var emoji: EmojiArtModel.Emoji
        var body: some View {
            Button { document.deleteEmoji(emoji)}
                label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                }
            .scaleEffect(0.75)
            
            
        }
    }
    
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        withAnimation {
            selectedEmojis = []

        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        
            return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)

        
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width  - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    @GestureState private var gestureEmojiZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture(_ emoji: EmojiArtModel.Emoji? = nil ) -> some Gesture {
        if !selectedEmojis.isEmpty {
           return MagnificationGesture()
            .updating($gestureEmojiZoomScale) { latestEmojiZoomScale, gestureEmojiZoomScale, _  in
                gestureEmojiZoomScale = latestEmojiZoomScale
            }
            .onEnded { finalEmojiZoomScaleValue in
                for emoji in document.emojis {
                    if isSelected(emoji) {
                        document.scaleEmoji(emoji, by: finalEmojiZoomScaleValue)
                    }
                }
            }
        } else {
            return MagnificationGesture()
                .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                    gestureZoomScale = latestGestureScale
                }
                .onEnded { gestureScaleAtEnd in
                    steadyStateZoomScale *= gestureScaleAtEnd
                }
        }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    @GestureState private var gestureStateDragEmojiOffset: CGSize = .zero
    
    private func panGesture(emoji: EmojiArtModel.Emoji? = nil) -> some Gesture {
        // if there no selected emojis pan the background
        if let emoji = emoji, selectedEmojis.contains(emoji.id) {
            return DragGesture()
               .updating($gestureStateDragEmojiOffset)
               { latestDragEmojiStateValue, gestureStateDragEmojiOffset, _  in
                gestureStateDragEmojiOffset = latestDragEmojiStateValue.translation
               }
               .onEnded { dragGestureValueAtEnd in
                   for emoji in document.emojis {
                       if isSelected(emoji) {
                        document.moveEmoji(emoji, by: (dragGestureValueAtEnd.translation / zoomScale))
                       }
                   }
               }
        } else {
            return DragGesture()
                .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                    gesturePanOffset = latestDragGestureValue.translation / zoomScale
                    print("Moving...'")
                }
                .onEnded { finalDragGestureValue in
                    steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale )
                }
        }
    }
    
    // MARK:- Tapping
    
    @State private var selectedEmojis = Set<Int>()
    
    private func selectGesture(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture().onEnded {
            withAnimation {
            selectedEmojis.toggleMatching(emoji)
            }
        }
    }
    
    private func isSelected(_ emoji: EmojiArtModel.Emoji) -> Bool {
        selectedEmojis.contains(emoji.id) ? true : false
    }
    
    private func singleTapOnBackground() -> some Gesture {
        TapGesture().onEnded {
            withAnimation {
                selectedEmojis = []
                longPressedEmojisId = []
            }
        }
    }
    
    private func selectionCircle(emoji: EmojiArtModel.Emoji) -> some View {
        Circle()
            .stroke(isSelected(emoji) ? Color.blue : Color.clear, lineWidth: 3)
            .scaleEffect( 1.3)
    }
    
    //MARK:- Long Pressing
    
    @State private var longPressedEmojisId = Set<Int>()
    private func longPressGesture(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        LongPressGesture()
            .onEnded { _ in
               return  withAnimation {
                     longPressedEmojisId.insert(emoji.id)
                }
            }
    }
    
    private func isLongPressed(_ emoji: EmojiArtModel.Emoji) -> Bool {
        longPressedEmojisId.contains(emoji.id) ? true : false
    }
    
   
    
    
  
    
    
    
    
    
    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
    
    
    
    
    
    
    
    
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
