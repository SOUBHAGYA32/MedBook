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
        
        //Checking if Already the Countries in the Entity
        do {
            let storedCountries = try context.fetch(fetchRequest)
            if !storedCountries.isEmpty {
                let countries = storedCountries.map { CountryModel(code: $0.code ?? "", name: $0.name ?? "") }
                completion(.success(countries))
                return
            }
        } catch {
            print("Error fetching Country from Core Data: \(error.localizedDescription)")
        }
        
        let url = APIEndpoints.countries
        AF.request(url).responseDecodable(of: CountriesResponse.self) { response in
            switch response.result {
            case .success(let data):
                let countries = data.data.map { CountryModel(code: $0.key, name: $0.value.country) }
                countries.forEach { country in
                    let entity = CountryEntity(context: self.context)
                    entity.code = country.code
                    entity.name = country.name
                }
                do {
                    try self.context.save()
                    print("Countries saved to Core Data")
                } catch {
                    print("Failed to save countries: \(error.localizedDescription)")
                }
                
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
    
    // Search Book API
    func fetchBooks(
        query: String,
        limit: Int,
        offset: Int,
        completion: @escaping (Result<[BookModel], Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "q": query,
            "limit": limit,
            "offset": offset,
            "fields": "key,title,author_name,ratings_average,ratings_count,cover_i"
        ]
        
        AF.request(APIEndpoints.bookURL, parameters: parameters)
            .validate()
            .responseDecodable(of: SearchBookResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let bookResponse):
                        let docs = bookResponse.docs ?? []
                        print("Response:::: \(response)")
                        completion(.success(docs))
                        
                    case .failure(let error):
                        print("Serach API Error:", error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
    }

}
