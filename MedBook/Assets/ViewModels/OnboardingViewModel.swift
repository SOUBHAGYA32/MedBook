//
//  OnboardingViewModel.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    static let shared = OnboardingViewModel()
    @Published var countries: [CountryModel] = []
    
    init() {
        fetchCountries()
        fetchIPConfig()
    }

    func fetchCountries() {
        APIManager.shared.fetchCountries { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self?.countries = countries
                case .failure(let error):
                    print("Country Fetch Error ::: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchIPConfig(){
        APIManager.shared.fetchIPInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("IP Fetched Successfully ::::: \(response)")
                case .failure(let error):
                    print("IP Fetch Error ::: \(error.localizedDescription)")
                }
            }
        }
    }
}
