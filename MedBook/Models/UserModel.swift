//
//  UserModel.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import Foundation
import FirebaseFirestore

struct UserModel : Codable {
  @DocumentID public var id: String?
  public var email: String
  public var country: String
  public var createdAt: Date
}

struct AuthCredentials {
  let email: String
  let password: String
  let country: String
}
