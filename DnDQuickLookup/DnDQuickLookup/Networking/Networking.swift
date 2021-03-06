//
//  Networking.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import Foundation

class Networking {
    enum NetworkError: Error {
        case failedFetch
        case noData
        case noDecode
    }

    let baseURL = URL(string: "https://www.dnd5eapi.co/api/")!

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    var dataLoader: NetworkDataLoader
    init(dataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }

    func fetchAllCategoriesFromAPI(completion: @escaping (Result<String, NetworkError>) -> Void) {
        let request = URLRequest(url: baseURL)
        dataLoader.loadData(using: request) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch categories with error: \(error)")
                completion(.failure(.failedFetch))
                return
            }

            guard let data = data else {
                NSLog("No data was returned.")
                completion(.failure(.noData))
                return
            }

            guard let convertedCategories = String(data: data, encoding: .utf8) else {
                NSLog("Failed to convert categories into string.")
                completion(.failure(.noDecode))
                return
            }
            completion(.success(convertedCategories))
        }
    }

    func fetchCategoryFromAPI(_ category: String, completion: @escaping (Result<ResultsModel, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent(category)
        let request = URLRequest(url: requestURL)
        dataLoader.loadData(using: request) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch category with error: \(error)")
                completion(.failure(.failedFetch))
                return
            }

            guard let data = data else {
                NSLog("No data returned")
                completion(.failure(.noData))
                return
            }

            do {
                let category = try self.jsonDecoder.decode(ResultsModel.self, from: data)
                completion(.success(category))
            } catch {
                NSLog("Error decoding category from server: \(error)")
                completion(.failure(.noDecode))
            }
        }
    }

    func fetchDetailFromAPI(categoryName: String, detailName: String, completion: @escaping (Result<DetailModel, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent(categoryName).appendingPathComponent(detailName)
        let request = URLRequest(url: requestURL)
        dataLoader.loadData(using: request) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch spell with error: \(error)")
                completion(.failure(.failedFetch))
                return
            }

            guard let data = data else {
                NSLog("No data in fetch")
                completion(.failure(.noData))
                return
            }

            do {
                let detail = try self.jsonDecoder.decode(DetailModel.self, from: data)
                completion(.success(detail))
            } catch {
                NSLog("Error decoding spell from server: \(error)")
                completion(.failure(.noDecode))
            }
        }
    }
}
