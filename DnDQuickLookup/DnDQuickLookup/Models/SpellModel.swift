//
//  SpellModel.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/2/21.
//

import Foundation

struct SpellModel: Codable {
    let name: String
    let desc: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case desc
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode([String].self, forKey: .desc)
    }
}
