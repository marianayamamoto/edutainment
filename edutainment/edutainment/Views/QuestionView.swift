//
//  QuestionView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/15/21.
//

import SwiftUI
struct AnimalImage: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 50)
    }
}
struct QuestionView: View {
    var gameMode: GameMode
    @Binding var currentQuestion: Question
    var numberOfQuestionsAsked: Int
    var totalQuestions: Int
    var answer: String

    var body: some View {
        Section(header: Text("Question \(numberOfQuestionsAsked + 1)/\(totalQuestions)")) {
            switch gameMode {
            case .numbers:
                Text("How much is \(currentQuestion.string)")
            case .animals:
                VStack {
                    HStack {
                        ForEach(0..<currentQuestion.firstNumber, id: \.self) { _ in
                            AnimalImage(imageName: currentQuestion.imageName)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    HStack {
                        HStack {
                            Text("X")
                        }
                        .frame(alignment: .leading)
                        HStack {
                            ForEach(0..<currentQuestion.secondNumber, id: \.self) { _ in
                                AnimalImage(imageName: currentQuestion.imageName)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            Text("\(answer)")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
