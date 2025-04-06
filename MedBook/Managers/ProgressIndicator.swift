//
//  ProgressIndicator.swift
//  MedBook
//
//  Created by Soubhagya on 06/04/25.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ProgressIndicator {
    static let shared = ProgressIndicator()
    private init(){}

    var activityIndicator : NVActivityIndicatorView!
    let topView = UIView()

    func setProgressIndicator(view: UIView){
        self.topView.frame = UIApplication.shared.keyWindow!.frame
        self.topView.backgroundColor = .clear
        self.topView.isHidden = true
        UIApplication.shared.keyWindow!.addSubview(self.topView)
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 80,height: 80))
        self.activityIndicator = NVActivityIndicatorView(frame: rect, type: .circleStrokeSpin, color: UIColor.blue, padding: 10)
        self.activityIndicator.backgroundColor = UIColor.clear
        self.activityIndicator.layer.cornerRadius = 8
        view.addSubview(self.activityIndicator)

        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0)
        ])
    }
    
    func show() {
        DispatchQueue.main.async {
            self.topView.isHidden = false
            self.activityIndicator.startAnimating()
            self.activityIndicator.superview?.isUserInteractionEnabled = false
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.topView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.superview?.isUserInteractionEnabled = true
        }
    }
}
