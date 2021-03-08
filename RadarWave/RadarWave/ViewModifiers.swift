//
//  ViewModifiers.swift
//  RadarWave
//
//  Created by 荒木辰造 on R 3/03/08.
//

import SwiftUI

extension Image {
    func defaultWrapper(
        width: CGFloat,
        borderWidth: CGFloat
    ) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(
                width: width,
                height: width
            )
            .cornerRadius(width / 2)
            .overlay(
                Circle()
                    .stroke(
                        Color.white,
                        lineWidth: borderWidth
                    )
            )
    }
}


#error("Paste https://www.avanderlee.com/swiftui/withanimation-completion-callback/ code here")

@available(iOS 13.0, *)
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    func body(content: Content) -> some View {
        content
    }
}

@available(iOS 13.0, *)
extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier())
    }
}
