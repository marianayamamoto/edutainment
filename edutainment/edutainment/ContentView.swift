//
//  ContentView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/14/21.
//

import Combine
import SwiftUI

enum GameMode {
    case settings
    case gameOn
}

struct Question: Equatable {
    let firstNumber: Int
    let secondNumber: Int

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

struct QuestionsView: View {
    let numberOfMultiplicationTables: Int
    let numberOfQuestions: Int
    @State private var questions: [Question] = []
    @State private var currentQuestion: Question = Question(firstNumber: 0, secondNumber: 0)
    @State private var answer = ""
    @State private var numberOfQuestionsAsked = 0
    @State private var score = 0
    @State private var answerErrorShowing = false

    var shouldLoadMoreQuestions: Bool {
        (numberOfQuestions == 0 || numberOfQuestionsAsked < numberOfQuestions) && numberOfQuestionsAsked < numberOfMultiplicationTables * numberOfMultiplicationTables
    }

    var intAnswer: Int {
        guard let answer = Int(answer) else {
            fatalError()
        }
        return answer
    }

    var totalQuestions: Int {
        if numberOfQuestions == 0 || numberOfQuestions > numberOfMultiplicationTables * numberOfMultiplicationTables {
            return numberOfMultiplicationTables * numberOfMultiplicationTables
        }
        return numberOfQuestions
    }

    var body: some View {
        Group {
            Form {
                if shouldLoadMoreQuestions {

                    Section(header: Text("Question \(numberOfQuestionsAsked + 1)/\(totalQuestions)")) {
                        Text("What is \(currentQuestion.string) ?")
                        TextField("Answer", text: $answer)
                            .keyboardType(.numberPad)
                            .onReceive(Just(answer)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.answer = filtered
                                }
                            }
                    }
                    Button("Next") {
                        if validateAnswer() {
                            answerErrorShowing = false
                            answer = ""
                            currentQuestion = newQuestion()
                        } else {
                            answerErrorShowing = true
                        }
                    }

                } else {
                    Section(header: Text("Game over!")) {
                        Text("You got \(score)/\(totalQuestions) questions correct!")
                    }
                    Button("Play again") {
                        newGame()
                    }
                }
            }
        }
        .onAppear(perform: {
            setupAllQuestions()
            currentQuestion = newQuestion()
        })
        .alert(isPresented: $answerErrorShowing) {
            Alert(title: Text("Error"), message: Text("Please write an answer..."), dismissButton: .default(Text("OK")) {
            })
        }
    }

    func newGame() {
        answer = ""
        numberOfQuestionsAsked = 0
        score = 0
        setupAllQuestions()
        currentQuestion = newQuestion()
    }

    func setupAllQuestions() {
        for i in 0..<self.numberOfMultiplicationTables {
            for j in 0..<self.numberOfMultiplicationTables {
                questions.append(Question(firstNumber: i+1, secondNumber: j+1))
            }
        }
    }

    func validateAnswer() -> Bool {
        guard !answer.isEmpty else {
            return false
        }
        numberOfQuestionsAsked += 1
        if currentQuestion.answer == intAnswer {
            score += 1
        }
        return true
    }

    func newQuestion() -> Question {
        let randomQuestion = questions.randomElement() ?? Question(firstNumber: 0, secondNumber: 0)
        if let questionIndex = questions.firstIndex(of: randomQuestion) {
            questions.remove(at: questionIndex)
        }
        return randomQuestion
    }
}

struct SettingsView: View {
    @Binding var numberOfMultiplicationTables: Int
    @Binding var numberOfQuestionsIndex: Int

    let numberOfQuestionsOptions: [Int]

    var body: some View {
        Group {
            Form {
                Section(header: Text("Game settings")) {
                    Stepper(value: $numberOfMultiplicationTables, in: 1...12, step: 1) {
                        Text("Up to x\(numberOfMultiplicationTables, specifier: "%d")")
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
}

struct ContentView: View {
    @State private var gameState: GameMode = .settings
    @State private var numberOfMultiplicationTables = 1
    @State private var numberOfQuestionsIndex = 0
    let numberOfQuestionsOptions = [5, 10, 20, 0]

    var body: some View {
        NavigationView {
            switch gameState {
            case .settings:
                SettingsView(numberOfMultiplicationTables: $numberOfMultiplicationTables, numberOfQuestionsIndex: $numberOfQuestionsIndex, numberOfQuestionsOptions: numberOfQuestionsOptions)
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
                QuestionsView(numberOfMultiplicationTables: numberOfMultiplicationTables, numberOfQuestions: numberOfQuestionsOptions[numberOfQuestionsIndex])
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                gameState = .settings
                            }) {
                                Text("Back")
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
