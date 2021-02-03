//
//  ResultsModel.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/3/21.
//

import Foundation

struct ResultsModel: Codable {
    var results: [CategoryResult]
}

struct CategoryResult: Codable {
    var index, name: String
}
