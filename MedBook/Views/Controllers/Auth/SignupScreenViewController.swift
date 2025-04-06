//
//  SignupScreenViewController.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import UIKit
import SwiftUI

class SignupScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        let signupView = UIHostingController(rootView: SignupView(onSignupSuccess: {
            self.handleSignupSccess()
        }, onLoginTapped: {
            self.handleLogin()
        }, onBackTapped: {
            self.navigationController?.popViewController(animated: true)
        }))
        addChild(signupView)
        signupView.view.frame = view.bounds
        view.addSubview(signupView.view)
        signupView.didMove(toParent: self)
    }
    
    //Login Success
    private func handleSignupSccess(){
        let tabBarController = MainTabBarController()
        tabBarController.selectedIndex = 0
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    private func handleLogin() {
        let loginVC = LoginScreenViewController()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
