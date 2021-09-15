//
//  GameOverView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/15/21.
//

import SwiftUI

struct GameOverView: View {
    var score: Int
    var totalQuestions: Int

    @State private var isAnimating = false
    @State private var showProgress = false
    @State private var animationAmount = 0.0

    var foreverAnimation: Animation {
        Animation.easeInOut(duration: 2)
            .repeatForever(autoreverses: true)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("You got \(score)/\(totalQuestions) questions correct!")
            if score == totalQuestions {
                Text("You got them all!!!")
                Button(action: { self.showProgress.toggle() }, label: {
                    if showProgress {
                        Text("🏆")
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear {
                                self.isAnimating = true
                                animationAmount = 360
                            }
                            .onDisappear {
                                self.isAnimating = false
                                self.animationAmount = 0.0
                            }
                    } else {
                        Text("🏆")
                    }

                })
                .onAppear { self.showProgress = true }
            } else if score == 0 {
                Text("Too bad...keep trying. 👊")
            } else {
                Text("Almost there... 👍")
            }

        }
        .font(.title)
    }
}
