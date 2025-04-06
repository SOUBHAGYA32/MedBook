//
//  CountryModel.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import Foundation

struct CountriesResponse: Decodable {
    let status: String
    let statusCode: Int
    let version: String
    let access: String
    let total: Int
    let offset: Int
    let limit: Int
    let data: [String: CountryInfo]
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version
        case access
        case total
        case offset
        case limit
        case data
    }
}

struct CountryInfo: Decodable {
    let country: String
    let region: String
}

struct CountryModel : Identifiable, Hashable {
    var id: String { code }
    let code: String
    let name: String
}

struct IPLocationResponse: Decodable {
    let status: String
    let country: String
    let countryCode: String
    let region: String
    let regionName: String
    
    enum CodingKeys: String, CodingKey {
        case status, country, countryCode, region, regionName
    }
}
