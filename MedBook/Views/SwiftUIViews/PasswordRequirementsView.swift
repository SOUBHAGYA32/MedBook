//
//  PasswordRequirementsView.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import SwiftUI

enum RequirementsType {
    case eightChar, spacialChar, oneDigit, upperCaseChar, confirmation
    
    var description: LocalizedStringKey {
        switch self {
        case .eightChar:
            return "At least 8 characters"
        case .spacialChar:
            return "Contains a special character"
        case .oneDigit:
            return "Contains a digit"
        case .upperCaseChar:
            return "Must contain an uppercase letter"
        case .confirmation:
            return "Password and confirmation match"
        }
    }
}

struct PasswordRequirementsView: View {
    var type: RequirementsType
    @Binding var toggleState: Bool
    var body: some View {
        HStack {
            Toggle("", isOn: $toggleState.animation(.easeInOut))
                .toggleStyle(CheckboxToggleStyle())
                .disabled(true)
                .frame(width: 20, height: 20)
            
            Text(type.description)
                .font(.poppins(.regular, size: 12))
                .foregroundStyle(Color.textColor)
            Spacer()
        }
    }
}

#Preview {
    PasswordRequirementsView(type: .upperCaseChar, toggleState: .constant(false))
}
