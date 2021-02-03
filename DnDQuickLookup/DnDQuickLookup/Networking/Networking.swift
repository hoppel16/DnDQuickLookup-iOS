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

    func fetchSpellFromAPI(spellName: String, completion: @escaping (Result<SpellModel, NetworkError>) -> Void) {
        let requestURL = baseURL.appendingPathComponent("spells").appendingPathComponent(spellName)
        let request = URLRequest(url: requestURL)
        dataLoader.loadData(using: request) { data, _, error in
            if let error = error {
                NSLog("Failed to fetch spell with error: \(error)")
                completion(.failure(.failedFetch))
            }

            guard let data = data else {
                NSLog("No data in fetch")
                completion(.failure(.noData))
                return
            }

            do {
                let spell = try self.jsonDecoder.decode(SpellModel.self, from: data)
                completion(.success(spell))
            } catch {
                NSLog("Error decoding spell from server: \(error)")
                completion(.failure(.noDecode))
            }
        }
    }
}
