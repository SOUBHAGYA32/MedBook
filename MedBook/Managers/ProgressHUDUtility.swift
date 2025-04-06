//
//  ProgressHUDUtility.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import Foundation
import SwiftUI
import ProgressHUD

class ProgressHUDUtility {
    //Show loading animation
    static func showLoading(text: String = "Loading...", interaction: Bool = false) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = .textColor
        ProgressHUD.colorAnimation = .blue
        if let customFont = UIFont(name: "Poppins-Regular", size: 16) {
            ProgressHUD.fontStatus = customFont
        }
        ProgressHUD.animate(text, interaction: interaction)
    }
    
    //Show success message with checkmark
    static func showSuccess(text: String = "Success!", delay: Double = 1.5) {
        ProgressHUD.succeed(text, delay: delay)
    }
    
    //Show failure message
    static func showFailure(text: String = "Failed") {
        ProgressHUD.failed(text)
    }

    //Dismiss the loader
    static func dismiss() {
        ProgressHUD.dismiss()
    }
    
    //Remove HUD from view
    static func remove() {
        ProgressHUD.remove()
    }
}
