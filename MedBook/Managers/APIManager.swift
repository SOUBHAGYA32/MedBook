//
//  APIManager.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import Foundation
import Alamofire
import UIKit
import CoreData

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Fetch countries from API
    func fetchCountries(completion: @escaping (Result<[CountryModel], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<CountryEntity> = CountryEntity.fetchRequest()
        
        let url = APIEndpoints.countries
        AF.request(url).responseDecodable(of: CountriesResponse.self) { response in
            switch response.result {
            case .success(let data):
                let countries = data.data.map { CountryModel(code: $0.key, name: $0.value.country) }
                completion(.success(countries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // Fetch IP-based country code
    func fetchIPInfo(completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIEndpoints.ipInfo
        AF.request(url).responseDecodable(of: IPLocationResponse.self) { response in
            switch response.result {
            case .success(let data):
                UserDefaults.standard.set(data.countryCode, forKey: "defaultCountryCode")
                completion(.success(data.countryCode))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
