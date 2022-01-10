//
//  Cardify.swift
//  Assignment Two
//
//  Created by yousef zuriqi on 03/11/2021.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
            
    }
    var rotation: Double
    var animatableData: Double {
        get {
            return rotation
        }
        set {
            rotation = newValue
        }
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20)
                if  rotation < 90 {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: 5)
                }else {
                    shape.fill()
                }
                content
                    .font(.system(size: scaleToFit(in: geometry.size)))
                    .opacity(rotation < 90 ? 1 : 0 )

            }
            .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0 ))

        }
    }
    private func scaleToFit(in size: CGSize) -> CGFloat {
         min(size.width, size.height) * 0.8
    }
}
