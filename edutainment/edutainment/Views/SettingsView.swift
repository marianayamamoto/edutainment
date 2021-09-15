//
//  SettingsView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/15/21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var numberOfMultiplicationTables: Int
    @Binding var numberOfQuestionsIndex: Int
    @Binding var gameMode: GameMode

    let numberOfQuestionsOptions: [Int]

    var body: some View {
        Group {
            Form {
                Section(header: Text("Number of multiplication tables")) {
                    Stepper(value: $numberOfMultiplicationTables, in: 1...12, step: 1) {
                        Text("Up to x\(numberOfMultiplicationTables, specifier: "%d")")
                    }
                }
                Section(header: Text("Number of questions")) {
                    Picker("Number of questions", selection: $numberOfQuestionsIndex) {
                        ForEach(0 ..< numberOfQuestionsOptions.count) {
                            if self.numberOfQuestionsOptions[$0] == 0 {
                                Text("All")
                            } else {
                                Text("\(numberOfQuestionsOptions[$0])")
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Game type")) {
                    Picker("Game mode", selection: $gameMode) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            Text("\(mode.string)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}
