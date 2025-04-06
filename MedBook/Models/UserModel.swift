//
//  UserModel.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import Foundation


// View model user struct
struct UserModel {
    var id: UUID
    var email: String
    var country: String
    var password: String
}

// Credentials struct
struct AuthCredentials {
    var email: String
    var password: String
}
