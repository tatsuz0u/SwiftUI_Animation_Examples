//
//  RadarWaveView.swift
//  RadarWave
//
//  Created by 荒木辰造 on R 3/03/08.
//

import SwiftUI

let avatarRadius: CGFloat = 118

@available(iOS 13.0, *)
struct RadarWaveView: View {
    // MARK: Bunches of properties
    let strokeOpacities: [Double] = [
        0.2, 0.15, 0.1, 0.05, 0.03
    ]
    let strokeRadiuses: [CGFloat] = [
        100, 150, 200, 280, 360
    ]
    
    let bubbleAvatarNames: [String] = {
        (1...8).map {
            "Image_\($0)"
        }
    }()
    let bubbleWidthes: [CGFloat] = [
        40, 41, 40, 42, 32, 45, 41, 32
    ]
    let bubbleOffsets: [CGSize] = [
        CGSize(width: -62.5, height: 103),
        CGSize(width: 88, height: 14.5),
        CGSize(width: -57.5, height: -100),
        CGSize(width: 93.5, height: 84),
        CGSize(width: 113.5, height: -27),
        CGSize(width: -110, height: 5.5),
        CGSize(width: 68, height: -93.5),
        CGSize(width: 113.5, height: -27)
    ]
    
    var strokeInfos: [StrokeInfo] {
        if strokeOpacities.count == 5,
           strokeRadiuses.count == 5
        {
            return (0..<5).map {
                StrokeInfo(
                    opacity: strokeOpacities[$0],
                    radius: strokeRadiuses[$0]
                )
            }
        } else {
            return []
        }
    }
    var bubbleInfos: [BubbleInfo] {
        if bubbleAvatarNames.count == 8,
           bubbleOffsets.count == 8,
           bubbleWidthes.count == 8
        {
            return (0..<8).map {
                BubbleInfo(
                    avatarName: bubbleAvatarNames[$0],
                    delay: Double(($0 + 1)) * 2/3,
                    width: bubbleWidthes[$0],
                    offset: bubbleOffsets[$0]
                )
            }
        } else {
            return []
        }
    }
 
    // MARK: RadarWaveView body
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            ForEach(strokeInfos) { strokeInfo in
                CircleBorder(info: strokeInfo)
            }
            CircleWave()
            CircleWave(delay: 2/3)
            ForEach(bubbleInfos) { bubbleInfo in
                AvatarBubble(info: bubbleInfo)
            }
            Image("avatar")
                .defaultWrapper(
                    width: avatarRadius,
                    borderWidth: 2
                )
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.light)
        .statusBar(hidden: true)
    }
}

// MARK: CircleBorder
@available(iOS 13.0, *)
private struct CircleBorder: View {
    let info: StrokeInfo
    
    var body: some View {
        Circle()
            .stroke(
                Color.white
                    .opacity(info.opacity),
                lineWidth: 1
            )
            .frame(
                width: info.radius + avatarRadius,
                height: info.radius + avatarRadius
            )
    }
}

// MARK: CircleWave
@available(iOS 13.0, *)
private struct CircleWave: View {
    @State var color = Color.white.opacity(0.11)
    @State var delay: Double = 0
    @State var radius: CGFloat = 24
    
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(
                width: radius + avatarRadius,
                height: radius + avatarRadius
            )
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: 4/3)
                        .repeatForever(autoreverses: false)
                        .delay(delay)
                ) {
                    radius = 200
                    color = Color.white.opacity(0)
                }
            }
    }
}

// MARK: AvatarBubble
@available(iOS 13.0, *)
private struct AvatarBubble: View {
    @State var didExecuteAnimation = false
    @State var opacity: Double = 0
    @State var degree: Double = 0
    @State var xOffset: CGFloat = 0
    let info: BubbleInfo
    let timer = Timer
        .publish(
            every: 6.1,
            on: .main,
            in: .common
        )
        .autoconnect()
    
    var body: some View {
        Image(info.avatarName)
            .defaultWrapper(
                width: info.width,
                borderWidth: 1
            )
            .offset(x: xOffset)
            .rotationEffect(
                Angle(degrees: degree)
            )
            .opacity(opacity)
            .offset(info.offset)
            .onAppear(perform: onAppear)
            .onReceive(timer) { _ in executeAnimation() }
            .onAnimationCompleted(for: opacity, completion: onAnimationComplete)
    }
    
    func onAppear() {
        if !didExecuteAnimation {
            executeAnimation()
        }
    }
    
    func executeAnimation() {
        didExecuteAnimation = true
        withAnimation(
            Animation
                .linear(duration: 1/2)
                .delay(info.delay)
        ) {
            opacity = 1
            degree = 18
            xOffset = 5
        }
    }
    func onAnimationComplete() {
        if opacity == 1 {
            withAnimation(
                Animation
                    .linear(duration: 1/2)
            ) {
                opacity = 0
                degree = -18
                xOffset = -5
            }
        }
    }
}

// MARK: Structs
@available(iOS 13.0, *)
struct StrokeInfo: Identifiable {
    var id = UUID()
    
    let opacity: Double
    let radius: CGFloat
}

@available(iOS 13.0, *)
struct BubbleInfo: Identifiable {
    var id = UUID()
    
    let avatarName: String
    let delay: Double
    let width: CGFloat
    let offset: CGSize
}
