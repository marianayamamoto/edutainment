//
//  GameOnView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/15/21.
//

import SwiftUI

struct GameOnView: View {
    let numberOfMultiplicationTables: Int
    let numberOfQuestions: Int
    let gameMode: GameMode
    let animals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale" , "zebra"]
    @State private var questions: [Question] = []
    @State private var currentQuestion: Question = Question(firstNumber: 0, secondNumber: 0, imageName: "")
    @State private var answer = ""
    @State private var numberOfQuestionsAsked = 0
    @State private var score = 0
    @State private var answerErrorShowing = false

    var randomAnimal: String {
        animals.randomElement() ?? "bear"
    }

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
            if shouldLoadMoreQuestions {
                Form {
                    QuestionView(gameMode: gameMode, currentQuestion: currentQuestion, numberOfQuestionsAsked: numberOfQuestionsAsked, totalQuestions: totalQuestions, answer: answer)
                    Section(header: Text("Tap the answer")) {
                        KeyPad(string: $answer, withDecimalPoint: false)
                            .font(.largeTitle)
                            .padding()
                    }
                    Section {
                        Button("Next") {
                            if validateAnswer() {
                                answerErrorShowing = false
                                answer = ""
                                currentQuestion = newQuestion()
                            } else {
                                answerErrorShowing = true
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center).padding()
                    }
                }
            } else {
                GameOverView(score: score, totalQuestions: totalQuestions)
                Button("Play again") {
                    newGame()
                }
            }
        }
        .navigationTitle(shouldLoadMoreQuestions ? "Game on!" : "Game over!")
        .onAppear(perform: {
            setupAllQuestions()
            currentQuestion = newQuestion()
        })
        .alert(isPresented: $answerErrorShowing) {
            Alert(title: Text("Error"), message: Text("Please give an answer..."), dismissButton: .default(Text("OK")) {
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
                questions.append(Question(firstNumber: i+1, secondNumber: j+1, imageName: randomAnimal))
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
        let randomQuestion = questions.randomElement() ?? Question(firstNumber: 0, secondNumber: 0, imageName: "")
        if let questionIndex = questions.firstIndex(of: randomQuestion) {
            questions.remove(at: questionIndex)
        }
        return randomQuestion
    }
}
