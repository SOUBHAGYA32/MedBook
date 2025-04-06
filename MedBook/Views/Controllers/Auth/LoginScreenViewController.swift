//
//  LoginScreenViewController.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import UIKit
import SwiftUI

class LoginScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        let loginView = UIHostingController(rootView: LoginView(onLoginSuccess: {
            self.handleLoginSccess()
        }, onRegisterTapped: {
            self.handleRegister()
        }, onBackTapped: {
            self.navigationController?.popViewController(animated: true)
        }))
        addChild(loginView)
        loginView.view.frame = view.bounds
        view.addSubview(loginView.view)
        loginView.didMove(toParent: self)
    }
    
    //Login Success
    private func handleLoginSccess(){
        let tabBarController = MainTabBarController()
        tabBarController.selectedIndex = 0
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    //Register Tapped
    private func handleRegister() {
        let signupVC = SignupScreenViewController()
        signupVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}
