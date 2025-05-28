//
//  CustomTextField.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI


struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var isPassword: Bool = false
    
    var body: some View {
        if isPassword {
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .foregroundStyle(Color.textColor)
                .font(.poppins(.regular, size: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 1)
                )
                .focused($isFocused)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .keyboardType(.default)
                .autocorrectionDisabled()
                .textContentType(.oneTimeCode)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .font(.poppins(.regular, size: 14))
                .foregroundStyle(Color.textColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 1)
                )
                .focused($isFocused)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
        }
    }
}
