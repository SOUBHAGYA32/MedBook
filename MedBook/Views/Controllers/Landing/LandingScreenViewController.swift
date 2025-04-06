//
//  LandingScreenViewController.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import UIKit
import SwiftUI

class LandingScreenViewController: UIViewController {
    
    private let viewModel = OnboardingViewModel.shared

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
        let loginVC = LoginScreenViewController()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func handleRegister() {
        let signupVC = SignupScreenViewController()
        signupVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}
