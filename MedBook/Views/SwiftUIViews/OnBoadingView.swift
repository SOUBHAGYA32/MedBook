//
//  OnBoadingView.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI

struct OnBoadingView: View {
    
    //Actions for Button  Taps
    var onLoginTapped: () -> Void
    var onRegisterTapped: () -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                Circle()
                    .fill(Color.placeHolderColor.opacity(0.2))
                    .offset(x: proxy.size.width/2, y: -(proxy.size.width/1))
                
                VStack {
                    Spacer()
                    
                    Image("boardingImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: proxy.size.width/1.2)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 10) {
                        
                        Text("Your Medical Library")
                            .font(.poppins(.bold, size: 30))
                            .foregroundColor(Color.blue)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        
                        Text("Explore all the existing job roles based on your interest and study major")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            onLoginTapped()
                        }) {
                            Text("Login")
                                .font(.poppins(.bold, size: 16))
                        }
                        .frame(width: 130, height: 45)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        
                        Button(action: {
                            onRegisterTapped()
                        }) {
                            Text("Signup")
                                .font(.poppins(.bold, size: 16))
                        }
                        .frame(width: 130, height: 45)
                        .foregroundColor(.textColor)
                        .background(Color.backgroundColor)
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    OnBoadingView(onLoginTapped: {}, onRegisterTapped: {})
}
