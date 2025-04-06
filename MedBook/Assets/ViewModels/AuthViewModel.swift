//
//  AuthViewModel.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import Foundation
import CoreData
import UIKit

// View model
final class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var isLoggedIn: Bool = false
  
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Register User
    func registerUser(withCredential authCredential: AuthCredentials, userModel: UserModel, completion: @escaping (Bool) -> ()) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", authCredential.email)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            guard existingUsers.isEmpty else {
                print("User already exists")
                completion(false)
                return
            }
            
            let newUser = UserEntity(context: context)
            newUser.id = UUID()
            newUser.email = authCredential.email
            newUser.password = authCredential.password
            newUser.country = userModel.country
            newUser.createdAt = Date()
            
            try context.save()
            
            self.currentUser = UserModel(id: newUser.id ?? UUID(),
                                         email: newUser.email ?? "",
                                         country: newUser.country ?? "",
                                         password: newUser.password ?? "")
            self.isLoggedIn = true
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
            UserDefaults.standard.set(newUser.email, forKey: UserDefaultsKeys.currentUserEmail)
            
            completion(true)
        } catch {
            print("Core Data Save Error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Login User
    func loginUser(withCredential authCredential: AuthCredentials, completion: @escaping (Bool) -> ()) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", authCredential.email, authCredential.password)
        
        do {
            let users = try context.fetch(fetchRequest)
            guard let user = users.first else {
                print("Invalid email or password")
                completion(false)
                return
            }
            
            self.currentUser = UserModel(id: user.id ?? UUID(),
                                         email: user.email ?? "",
                                         country: user.country ?? "",
                                         password: user.password ?? "")
            self.isLoggedIn = true
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
            UserDefaults.standard.set(user.email, forKey: UserDefaultsKeys.currentUserEmail)
            
            completion(true)
        } catch {
            print("Login Fetch Error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Logout User
    func logoutUser(completion: @escaping (Bool) -> ()) {
        self.currentUser = nil
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.currentUserEmail)
        completion(true)
    }
}

