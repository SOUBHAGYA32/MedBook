//
//  AuthViewModel.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: UserModel?

  //Data Base
  private let auth = Auth.auth()
  private let firestore = Firestore.firestore()

  let USER_STORE = Firestore.firestore().collection("users")

  private let isLoggedInKey = "isLoggedIn"
  private let currentUserIdKey = "currentUserId"

  //Register User
  func registerUser(withCredential authCredential: AuthCredentials, userModel: UserModel, completion: @escaping (Bool) -> ()) {
    self.auth.createUser(withEmail: authCredential.email, password: authCredential.password) { result, error in
      if let error = error {
        print("Error Creating User: \(error.localizedDescription)")
        completion(false)
        return
      }

      guard let user = result?.user else {
        print("Error: User not found after creation.")
        completion(false)
        return
      }

      var newUserModel = userModel
      newUserModel.id = user.uid
      newUserModel.createdAt = Date()

      do {
        try self.USER_STORE.document(user.uid).setData(from: newUserModel) { firestoreError in
          if let firestoreError = firestoreError {
            print("Firestore Save Error: \(firestoreError.localizedDescription)")
            completion(false)
          } else {
            self.userSession = user
            self.currentUser = newUserModel
            UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
            UserDefaults.standard.set(user.uid, forKey: self.currentUserIdKey)
          }
        }
      } catch {
        print("Firestore Encoding Error: \(error.localizedDescription)")
        completion(false)
      }
    }
  }


  //Login User
  func loginUser(withCredential authCredential: AuthCredentials, completion: @escaping (Bool) -> ()){
    self.auth.signIn(withEmail: authCredential.email, password: authCredential.password) { (result, error) in
      if let error = error {
        print("Error Signing In User: \(error.localizedDescription)")
        completion(false)
        return
      }


      guard let user = result?.user else {
        print("Error: No user found during login.")
        completion(false)
        return
      }
      self.userSession = user
      self.USER_STORE.document(user.uid).getDocument { snapshot, error in
        if let error = error {
          print("Error fetching user from Firestore: \(error.localizedDescription)")
          completion(false)
          return
        }

        guard let document = snapshot, document.exists,
              let userModel = try? document.data(as: UserModel.self) else {
          print("Error decoding user model")
          completion(false)
          return
        }

        self.currentUser = userModel
        UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
        UserDefaults.standard.set(user.uid, forKey: self.currentUserIdKey)
        print("Login successful and user data fetched")
        completion(true)
      }
    }
  }


  //Logout User
  func logoutUser(completion: @escaping (Bool) -> ()) {
    do {
      try auth.signOut()
      userSession = nil
      currentUser = nil
      UserDefaults.standard.removeObject(forKey: isLoggedInKey)
      UserDefaults.standard.removeObject(forKey: currentUserIdKey)
      print("Logout successful")
      completion(true)
    } catch {
      print("Error signing out: \(error.localizedDescription)")
      completion(false)
    }
  }
    
    
}

