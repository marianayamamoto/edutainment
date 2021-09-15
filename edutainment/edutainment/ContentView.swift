//
//  ContentView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/14/21.
//

import Combine
import SwiftUI

enum GameState {
    case settings
    case gameOn
}

enum GameMode: CaseIterable {
    case numbers
    case animals

    var string: String {
        switch self {
        case .numbers: return "Numerical"
        case .animals: return "Animals"
        }
    }
}

struct Question: Equatable {
    let firstNumber: Int
    let secondNumber: Int
    let imageName: String

    var string: String {
        "\(firstNumber)x\(secondNumber)"
    }

    var answer: Int {
        firstNumber * secondNumber
    }

    static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.firstNumber == rhs.firstNumber && lhs.secondNumber == rhs.secondNumber
    }
}



struct ContentView: View {
    @State private var gameState: GameState = .settings
    @State private var numberOfMultiplicationTables = 1
    @State private var numberOfQuestionsIndex = 0
    @State private var gameMode: GameMode = .numbers
    let numberOfQuestionsOptions = [5, 10, 20, 0]

    var body: some View {
        NavigationView {
            switch gameState {
            case .settings:
                SettingsView(numberOfMultiplicationTables: $numberOfMultiplicationTables, numberOfQuestionsIndex: $numberOfQuestionsIndex, gameMode: $gameMode, numberOfQuestionsOptions: numberOfQuestionsOptions)
                    .navigationTitle("Multiplication Practice")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                gameState = .gameOn
                            }) {
                                Text("Play")
                            }
                        }
                    }
            case .gameOn:
                GameOnView(numberOfMultiplicationTables: numberOfMultiplicationTables, numberOfQuestions: numberOfQuestionsOptions[numberOfQuestionsIndex], gameMode: gameMode)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                gameState = .settings
                            }) {
                                Text("Settings")
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 1, totalQuestions: 1)
        ContentView()
    }
}
