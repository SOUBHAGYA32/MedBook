//
//  SignupView.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel = OnboardingViewModel.shared
    @ObservedObject private var authViewModel = AuthViewModel()
    
    //Actions for Button  Taps
    var onSignupSuccess: (() -> Void)?
    var onLoginTapped: (() -> Void)?
    var onBackTapped: (() -> Void)?
    
    //Properties
    //Email
    @State private var emailID: String = ""
    
    //Password
    @State private var password: String = ""
    @State private var country: String = UserDefaults.standard.string(forKey: "defaultCountryCode") ?? ""
    
    //Password Checks
    @State private var hasEightChar = false
    @State private var hasSpacialChar = false
    @State private var hasOneDigit = false
    @State private var hasOneUpperCaseChar = false
    @State private var areAllFieldsValid = false
    @State private var isEmailValid = false

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading)  {
                Color.backgroundColor.ignoresSafeArea()
                
                Circle()
                    .fill(Color.placeHolderColor)
                    .offset(x: proxy.size.width/2, y: -(proxy.size.width/1.3))
                
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
                           Text("Signup here")
                                .font(.poppins(.bold, size: 30))
                                .foregroundColor(.blue)
                                .lineLimit(1)
                            
                            Text("Signup here so you can explore all the books")
                                .font(.poppins(.regular, size: 14))
                                .foregroundStyle(Color.gray)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                
                        }
                       
                        VStack {
                            CustomTextField(placeholder: "Email", text: $emailID)
                                
                            
                            VStack(spacing: 10) {
                                CustomTextField(placeholder: "Password", text: $password, isPassword: true)
                                
                                VStack(alignment: .leading) {
                                    PasswordRequirementsView(type: .eightChar, toggleState: $hasEightChar)
                                    PasswordRequirementsView(type: .spacialChar, toggleState: $hasSpacialChar)
                                    PasswordRequirementsView(type: .oneDigit, toggleState: $hasOneDigit)
                                    PasswordRequirementsView(type: .upperCaseChar, toggleState: $hasOneUpperCaseChar)
                                }
                            }
                            .padding(.top, 5)
                        }
                        
                        
                        //Country
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Country")
                                .font(.poppins(.medium, size: 14))
                                .foregroundColor(.gray)

                            Picker(selection: $country, label: Text("Country")) {
                                ForEach(viewModel.countries, id: \.self) { countryItem in
                                    HStack {
                                        Text(flag(for: countryItem.code)) // Get emoji flag
                                        Text(countryItem.name)
                                    }
                                    .tag(countryItem.code)
                                }
                            }
                            .frame(height: 140)
                            .clipped()
                            .pickerStyle(.wheel)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            self.handleSignup()
                        }) {
                            Text("Signup")
                                .font(.poppins(.bold, size: 18))
                                .foregroundColor(Color.backgroundColor)
                        }
                        .frame(width: proxy.size.width - 40, height: 50)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding(.vertical, 30)
                        .disableWithOpacity(!areAllFieldsValid)
                        
                        HStack( spacing: 6, content: {
                            Text("Already have an account?")
                                .font(.poppins(.regular, size: 14))
                                .foregroundStyle(Color.textColor)
                            
                            Button("Login") {
                                onLoginTapped?()
                            }
                            .font(.poppins(.bold, size: 14))
                            .tint(.blue)
                        })
                    }
                    .padding(.top, 80)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
                .onChange(of: password) { _ in
                    validatePassword()
                }
                .onChange(of: emailID) { _ in
                    validateEmail()
                }
                .keyboardIgnoring(padding: 100)
            }
        }
        .onAppear(perform: {
            print("Countries:", viewModel.countries)
        })
    }
    
    
    //Password Validations
    private func validatePassword() {
        hasEightChar = password.count >= 8
        hasSpacialChar = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|:\"';<>,.?/~`")) != nil
        hasOneDigit = password.contains { $0.isNumber }
        hasOneUpperCaseChar = password.contains { $0.isUppercase }
        updateFormValidity()
    }
    
    //Email
    private func validateEmail() {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: emailID)
        updateFormValidity()
    }
    
    //Updating the validations if all are true
    private func updateFormValidity() {
        areAllFieldsValid = isEmailValid && hasEightChar && hasSpacialChar && hasOneDigit && hasOneUpperCaseChar
    }
    
    //Flag
    func flag(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            flagString.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return flagString
    }
    
    
    func handleSignup(){
        print("Signup Button Tapped")
        print("Email: \(emailID)")
        print("Password: \(password)")
        print("Country Code: \(country)")
        ProgressHUDUtility.showLoading(text: "Signing you up...")
        let credentials = AuthCredentials(email: emailID, password: password)
        let user = UserModel(id: UUID(), email: emailID, country: country, password: password)
        authViewModel.registerUser(withCredential: credentials, userModel: user) { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if success {
                    ProgressHUDUtility.showSuccess(text: "Signup Successful!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ProgressHUDUtility.dismiss()
                        onSignupSuccess?()
                    }
                } else {
                    ProgressHUDUtility.showFailure(text: "User already exists!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        ProgressHUDUtility.dismiss()
                    }
                }
            }
        }
    }
}
