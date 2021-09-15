//
//  ContentView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/14/21.
//

import SwiftUI

enum GameMode {
    case settings
    case gameOn
}

struct QuestionsView: View {
    var body: some View {
        Text("Here are some questions")
    }
}

struct SettingsView: View {
    @Binding var numberOfMultiplicationTables: Int
    @Binding var numberOfQuestionsIndex: Int

    private let numberOfQuestionsOptions = [5, 10, 20, 0]

    var body: some View {
        Form {
            Section(header: Text("Game settings")) {
                Stepper(value: $numberOfMultiplicationTables, in: 1...12, step: 1) {
                   Text("Up to x\(numberOfMultiplicationTables, specifier: "%d") multiplication tables")
                }
                Picker("Number of questions", selection: $numberOfQuestionsIndex) {
                    ForEach(0 ..< numberOfQuestionsOptions.count) {
                        if self.numberOfQuestionsOptions[$0] == 0 {
                            Text("All")
                        } else {
                            Text("\(numberOfQuestionsOptions[$0])")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var gameState: GameMode = .settings
    @State private var numberOfMultiplicationTables = 1
    @State private var numberOfQuestionsIndex = 0

    var body: some View {
        NavigationView {
            switch gameState {
            case .settings:
                SettingsView(numberOfMultiplicationTables: $numberOfMultiplicationTables, numberOfQuestionsIndex: $numberOfQuestionsIndex)
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
                QuestionsView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            gameState = .settings
                        }) {
                            Text("Back")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // reset game
                        }) {
                            Text("New Game")
                        }
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
