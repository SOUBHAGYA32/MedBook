//
//  CheckboxToggle.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import SwiftUI


struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(configuration.isOn ? .blue : .white)
            .overlay {
                if !configuration.isOn {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 2)
                }
            }
            .cornerRadius(4)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}


