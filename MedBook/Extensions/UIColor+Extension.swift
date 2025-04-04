//
//  UIColor+Extension.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
  static let primaryColor = UIColor(hex: "#5DCEFD")
  static let textColor = UIColor(hex: "#101010")
  static let descriptionColor = UIColor(hex: "#A8A8A8")
  static let backgroundColor = UIColor(hex: "#FFFFFF")
  static let placeHolderColor = UIColor(hex: "#3A4049")

  convenience init(hex: String) {
    let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
    if hex.hasPrefix("#") {
      scanner.currentIndex = hex.index(after: hex.startIndex)
    }

    var rgbValue: UInt64 = 0
    scanner.scanHexInt64(&rgbValue)

    let r = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
    let g = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
    let b = CGFloat(rgbValue & 0xFF) / 255.0

    self.init(red: r, green: g, blue: b, alpha: 1.0)
  }
}

extension Color {
  static let primaryColor = Color(UIColor(hex: "#5DCEFD"))
  static let textColor = Color(UIColor(hex: "#101010"))
  static let descriptionColor = Color(UIColor(hex: "#A8A8A8"))
  static let backgroundColor = Color(UIColor(hex: "#FFFFFF"))
  static let placeHolderColor = Color(UIColor(hex: "#F8F9FF"))
}
