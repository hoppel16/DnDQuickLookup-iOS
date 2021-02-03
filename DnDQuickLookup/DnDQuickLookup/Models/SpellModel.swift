//
//  SpellModel.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import Foundation

struct SpellModel: Codable {
    let index, name: String
    let desc: [String]?

    enum CodingKeys: String, CodingKey {
        case index
        case name
        case desc
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        index = try container.decode(String.self, forKey: .index)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decodeIfPresent([String].self, forKey: .desc)
    }
}
