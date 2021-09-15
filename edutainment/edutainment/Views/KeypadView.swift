//
//  KeypadView.swift
//  edutainment
//
//  Created by Mariana Yamamoto on 9/15/21.
//

import SwiftUI

struct KeyPad: View {
    @Binding var string: String
    var withDecimalPoint: Bool

    var body: some View {
        VStack {
            KeyPadRow(keys: ["1", "2", "3"])
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            if withDecimalPoint {
                KeyPadRow(keys: [".", "0", "⌫"])
            } else {
                KeyPadRow(keys: ["0", "⌫"])
            }
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }

    private func keyWasPressed(_ key: String) {
        switch key {
        case "." where string.contains("."): break
        case "." where string == "0": string += key
        case "⌫":
            if !string.isEmpty {
                string.removeLast()
            }
        case _ where string == "0": string = key
        default: string += key
        }
    }
}
