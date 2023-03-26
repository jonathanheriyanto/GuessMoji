//
//  ButtonStyle.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import SwiftUI

struct GuessMojiBtn: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.title2, design: .rounded))
            .bold()
            .padding(14)
            .background(configuration.isPressed ? Color("darkOrange") : Color("darkOrange"))
            .cornerRadius(17.0)
            .foregroundColor(Color("forBg"))
    }
}

struct GuessMojiBtn2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded))
            .bold()
            .padding(10)
            .background(configuration.isPressed ? Color("forBg") : Color("forBg"))
            .cornerRadius(10.0)
            .foregroundColor(Color("darkOrange"))
    }
}

struct stateChange: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        stateButton(configuration: configuration)
    }

    struct stateButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.system(.body, design: .rounded))
                .bold()
                .padding(14)
                .background(isEnabled ? Color("darkOrange") : Color("lightGray"))
                .cornerRadius(8.0)
                .foregroundColor(isEnabled ? Color("forBg") : Color.white)
        }
    }
}

struct stateChange2: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        stateButton(configuration: configuration)
    }

    struct stateButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.system(.body, design: .rounded))
                .bold()
                .cornerRadius(8.0)
                .foregroundColor(isEnabled ? Color("darkOrange") : Color("lightGray"))
        }
    }
}
