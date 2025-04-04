//
//  LandingScreenViewController.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import UIKit
import SwiftUI

class LandingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        let onboardingView = UIHostingController(rootView: OnBoadingView(
            onLoginTapped: {
                self.handleLogin()
            },
            onRegisterTapped: {
                self.handleRegister()
            }
        ))
        
        addChild(onboardingView)
        onboardingView.view.frame = view.bounds
        view.addSubview(onboardingView.view)
        onboardingView.didMove(toParent: self)
    }
    
    private func handleLogin() {
        print("Login button tapped - Navigate to Login Screen")
    }
    
    private func handleRegister() {
        print("Register button tapped - Navigate to Register Screen")
    }
}
