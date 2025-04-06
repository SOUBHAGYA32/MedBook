//
//  LoginView.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = OnboardingViewModel.shared
    @ObservedObject private var authViewModel = AuthViewModel()
    
    //Actions for Button  Taps
    var onLoginSuccess: (() -> Void)?
    var onRegisterTapped: (() -> Void)?
    var onBackTapped: (() -> Void)?
    
    //Properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading)  {
                Color.backgroundColor.ignoresSafeArea()
                
                Circle()
                    .fill(Color.placeHolderColor)
                    .offset(x: proxy.size.width/2, y: -(proxy.size.width/0.9))
                
                Button(action: {
                   onBackTapped?()
                }) {
                    Circle()
                        .fill(Color.placeHolderColor)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(Color.textColor)
                        }
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                .zIndex(1)
                
                ScrollView(.vertical, showsIndicators: false) {
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
                            self.handleLogin()
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
                                onRegisterTapped?()
                            }
                            .font(.poppins(.bold, size: 14))
                            .tint(.blue)
                        })
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                    .frame(height: proxy.size.height)
                }
                .keyboardIgnoring()
            }
        }
    }
    
    func handleLogin() {
        print("Login Button Tapped")
        print("Email: \(emailID)")
        print("Password: \(password)")
        
        ProgressHUDUtility.showLoading(text: "Logging you in...")
        
        let credentials = AuthCredentials(email: emailID, password: password)
        authViewModel.loginUser(withCredential: credentials) { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if success {
                    ProgressHUDUtility.showSuccess(text: "🎉 Welcome back, \(emailID)!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ProgressHUDUtility.dismiss()
                        onLoginSuccess?()
                    }
                } else {
                    ProgressHUDUtility.showFailure(text: "Login failed. Incorrect email or password.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        ProgressHUDUtility.dismiss()
                    }
                }
            }
        }
    }
}


extension View {
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
}
