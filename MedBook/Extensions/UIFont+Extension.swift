//
//  UIFont+Extension.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import SwiftUI
import UIKit

extension UIFont {

  static func poppinsRegular(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
  }

  static func poppinsMedium(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "Poppins-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
  }

  static func poppinsSemiBold(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "Poppins-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
  }

  static func poppinsBold(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "Poppins-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
  }

  static var headerFont: UIFont {
    return poppinsBold(ofSize: 24)
  }

  static var headerDescriptionFont: UIFont {
    return poppinsRegular(ofSize: 16)
  }

  static var buttonFont: UIFont {
    return poppinsMedium(ofSize: 18)
  }

  static var normalTextFont: UIFont {
    return poppinsRegular(ofSize: 14)
  }
}

extension Font {
    static func poppins(_ weight: PoppinsFontWeight, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}

enum PoppinsFontWeight: String {
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}
