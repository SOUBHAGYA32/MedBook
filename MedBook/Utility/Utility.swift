//
//  Utility.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import Foundation

struct APIEndpoints {
    static let countries = "https://api.first.org/data/v1/countries?limit=249&pretty=true"
    static let ipInfo = "http://ip-api.com/json"
    static let bookURL = "https://openlibrary.org/search.json"
}

struct UserDefaultsKeys {
    static let isLoggedIn = "isLoggedInKey"
    static let currentUserEmail = "currentUserIdKey"
}
