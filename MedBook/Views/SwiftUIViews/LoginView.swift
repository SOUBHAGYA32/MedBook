//
//  LoginView.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI

struct LoginView: View {
    
    //Properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                Circle()
                    .fill(Color.placeHolderColor)
                    .offset(x: proxy.size.width/2, y: -(proxy.size.width/0.9))
                
                VStack {
                  
                    VStack(alignment: .center, spacing: 10) {
                       Text("Login here")
                            .font(.poppins(.bold, size: 30))
                            .foregroundColor(.blue)
                            .lineLimit(1)
                        
                        Text("Welcome back you’ve\nbeen missed!")
                            .font(.poppins(.regular, size: 14))
                            .foregroundStyle(Color.gray)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
            
                    }
                   
                    
                    CustomTextField(placeholder: "Email", text: $emailID)
                        .padding(.vertical, 20)
                    
                    CustomTextField(placeholder: "Password", text: $password, isPassword: true)
                        .padding(.vertical, 5)
                    
                    Button(action: {
                        // Handle login action
                    }) {
                        Text("Login")
                            .font(.poppins(.bold, size: 18))
                            .foregroundColor(Color.backgroundColor)
                    }
                    .frame(width: proxy.size.width - 40, height: 50)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(.vertical, 30)
                    .disableWithOpacity(emailID.isEmpty || password.isEmpty)
                    
                    HStack( spacing: 6, content: {
                        Text("Don't have an account?")
                            .font(.poppins(.regular, size: 14))
                            .foregroundStyle(Color.textColor)
                        
                        Button("SignUp") {
                           // Signup
                        }
                        .font(.poppins(.bold, size: 14))
                        .tint(.blue)
                    })
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    LoginView()
}


extension View {
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
}
