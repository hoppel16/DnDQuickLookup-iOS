//
//  NetworkDataLoader.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
