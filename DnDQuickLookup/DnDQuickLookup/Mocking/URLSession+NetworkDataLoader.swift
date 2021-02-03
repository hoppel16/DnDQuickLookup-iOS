//
//  URLSession+NetworkDataLoader.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
